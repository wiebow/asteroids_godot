
# player object script

extends "res://objects/BaseObject.gd"

# player can send this signal
# these signals are connected to the play scene in the editor.
signal player_died
signal player_warp
signal game_over

# variables for easier coding
onready var player_sprite = $ObjectSprite

const THRUST : float = 10.0
const MAX_SPEED : float = 400.0
const ROTATION_SPEED : float = 5.0 * 60

var dead : bool

# used to find the parent scene. we add bullets to it
# and it also holds the score counter scenes etc.
# var my_parent

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	my_parent = get_node("../")


# performed ONCE per frame
func _physics_process(delta) -> void:

	if dead == true:
		return

	if Input.is_action_pressed("player_left"):
		rotation_degrees -= delta * ROTATION_SPEED
	elif Input.is_action_pressed("player_right"):
		rotation_degrees += delta * ROTATION_SPEED

	if Input.is_action_just_pressed("player_fire"):
		_create_bullet()

	if Input.is_action_just_pressed("player_warp"):
		_do_warp()

	# get acceleration if thrust is pressed
	if Input.is_action_pressed("player_thrust"):
		var acceleration : Vector2

		# -THRUST because vector pointing up = y value of -1
		#
		# rotated method of Vector2 needs a radian, not degrees,
		# so convert that using deg2rad
		acceleration = Vector2(0, -THRUST).rotated(deg2rad(rotation_degrees))

		# add acceleration to current speed
		velocity += acceleration

	# dampen a bit
	velocity *= 0.98

	# cap speed
	if velocity.length() > MAX_SPEED:
		velocity = velocity.normalized() * MAX_SPEED
		# velocity is added to position in BaseObject.gd


# get ready to play
func reset() -> void:
	rotation_degrees = 0
	velocity = Vector2(0, 0)

	# position player in center (.size returns a Vector2)
	# divide method returns a new Vector2 , so we can keep doing this.
	position = screen_size / 2

	_invincible()
	dead = false
	player_sprite.visible = true


func _create_bullet() -> void :
	var scene = load("res://objects/bullets/PlayerBullet.tscn")
	var bullet = scene.instance()

	# set position and speed
	bullet.initialize( position, rotation_degrees )
	my_parent.add_child(bullet)
	$BulletSoundPlayer.play()


# warps player to another screen position and slows down
func _do_warp() -> void:
	if Game.player_warps:
		Game.player_warps -= 1
		emit_signal("player_warp")

		# play on this location
		$WarpSoundPlayer.play()
		# change location
		var screen_size = get_viewport_rect().size
		position = Vector2(
			rand_range(50, screen_size.x-50),
			rand_range(50, screen_size.y-50))
		velocity /= 4


func _invincible():
	# activate invincible animation
	$InvincibleTimer.start(2.5)
	$InvinciblePlayer.play("invincible_flash")


func is_invincible() -> bool:
	return $InvinciblePlayer.is_playing()


# called when invincibility timer runs out
# stops the animation
func _on_InvincibleTimer_timeout() -> void:
	$InvinciblePlayer.stop()
	player_sprite.visible = true


func _on_Player_area_entered(area):
	if is_invincible() == true:
		return
	if dead == true:
		return

	if area.is_in_group("asteroids"):
		die()
	elif area.is_in_group("saucer"):
		die()
	elif area.is_in_group("saucer_bullets"):
		die()


func die() -> void:
	my_parent.create_explosion(position)
	Game.player_spare_lives -= 1

	dead = true
	player_sprite.visible = false
	velocity = Vector2(0, 0)
	position = screen_size / 2

	if Game.player_spare_lives == -1:
		emit_signal("game_over")
	else:
		emit_signal("player_died")
		# wait a while before we are returning control to the player
		$DeathTimer.start(2)


func _on_DeathTimer_timeout():
	reset()
