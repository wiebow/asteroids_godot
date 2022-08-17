# player.gd

extends "res://objects/base_object.gd"
class_name Player

const THRUST : float = 10.0
const MAX_SPEED : float = 400.0
const ROTATION_SPEED : float = 5.0 * 60

var dead : bool
var lives : int = 0
var warps : int = 0
var bullet_node : Node2D

# variables for easier coding
onready var player_sprite : Sprite = $ObjectSprite
onready var warp_sound : AudioStreamPlayer2D = $WarpPlayer
onready var bullet_sound : AudioStreamPlayer2D = $BulletPlayer

onready var delay_timer : Timer = $DelayTimer
onready var invincible_timer : Timer = $InvincibleTimer
onready var collision_shape : CollisionPolygon2D = $CollisionPolygon2D


func _ready() -> void:
	pass


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

		# -THRUST because vector pointing up = y value of -1, and
		# rotated() method of Vector2 needs a radian, not degrees,
		# so convert that using deg2rad
		acceleration = Vector2(0, -THRUST).rotated(deg2rad(rotation_degrees))

		# add acceleration to current speed
		velocity += acceleration

	# dampen a bit
	velocity *= 0.98

	# cap speed
	if velocity.length() > MAX_SPEED:
		velocity = velocity.normalized() * MAX_SPEED
		# velocity vector is added to position in BaseObject.gd


# get ready to play a level
# this is called by the Play scene when a level starts
func reset() -> void:
	rotation_degrees = 0
	velocity = Vector2(0, 0)

	# position player in center (.size returns a Vector2)
	# Vector divide method returns a new Vector2 , so we can keep doing this.
	position = screen_size / 2

	invincible()
	dead = false
	player_sprite.visible = true


# the play scene listens to the game_over event
func die() -> void:
	Events.emit_signal("create_explosion", self.position)

	dead = true
	player_sprite.visible = false
	
	lives -= 1	
	if lives == -1:
		Events.emit_signal("game_over")
	else:
		Events.emit_signal("gui_change_lives", lives)
		delay_timer.start()


# make the player invincible for 2.5 seconds
func invincible() -> void:
	collision_shape.disabled = true
	invincible_timer.start(2.5)
	$InvinciblePlayer.play("invincible_flash")


func is_invincible() -> bool:
	return collision_shape.disabled


func _create_bullet() -> void:
	bullet_sound.play()
	Events.emit_signal("create_bullet", position, rotation_degrees)


# warps player to another screen position and slows down
func _do_warp() -> void:
	if warps:
		warps -= 1
		Events.emit_signal("gui_change_warps", warps)

		warp_sound.play()

		# change player location
		var screen_size: Vector2 = get_viewport_rect().size
		position = Vector2(
			rand_range(50, screen_size.x-50),
			rand_range(50, screen_size.y-50))
			
		# slow down after warp
		velocity /= 4


func _on_InvincibleTimer_timeout() -> void:
	collision_shape.disabled = false
	$InvinciblePlayer.stop()
	player_sprite.visible = true


# we only check what can kill us
func _on_Player_area_entered(area) -> void:
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
		area.queue_free()


func _on_DeathTimer_timeout() -> void:
	reset()
