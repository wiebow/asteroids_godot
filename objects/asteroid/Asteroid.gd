
extends "res://objects/BaseObject.gd"

# award for player
var score_award : int
# angle changes this amount per frame
var rotation_dir = 0

# 1 is big, 2 is medium, 3 is small
var my_size:int

# asteroid can send these signals
# these signals are listened to from the PlayScene.
signal asteroid_exploded(position, size)
signal asteroid_hit_by_bullet(score_award)


# Called when the node enters the scene tree for the first time.
func _ready():
	# give it a nice random color
	$AsteroidSprite.modulate = Color(
		rand_range(0.4, 1.0),
		rand_range(0.5, 1.0),
		rand_range(0.4, 1.0), 1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# turn a bit
	rotation += rotation_dir * delta


func initialize(size : int) -> void:
	my_size = size
	$AsteroidSprite.apply_scale((Vector2(3.5, 3.5)))

	# choose the right size by selecting the right animation frame
	# and adjust the size of the collision shape
	# rotate faster when smaller
	match size:
		1:
			$AsteroidSprite.play("big")
			rotation_dir = rand_range(-1, 1)
#			$AsteroidSprite.apply_scale((Vector2(3.5, 3.5)))
			$ObjectCollision.apply_scale(Vector2(9.0, 9.0))
			score_award = 100
		2:
			$AsteroidSprite.play("normal")
			rotation_dir = rand_range(-2, 2)
#			$AsteroidSprite.apply_scale((Vector2(3.0, 3.0)))
			$ObjectCollision.apply_scale(Vector2(5.0, 5.0))
			score_award = 150
		3:
			$AsteroidSprite.play("small")
			rotation_dir = rand_range(-4, 4)
			$AsteroidSprite.apply_scale((Vector2(0.8, 0.8)))
			$ObjectCollision.apply_scale(Vector2(2.0, 2.0))
			score_award = 300

	# set velocity according to size
	set_velocity(randi() % 25 + (size * 30))



func set_velocity(speed):
	# rocks always go into a random direction
	velocity = Vector2(rand_range(-1, 1), rand_range(-1, 1))
	velocity *= speed


# We only check groups that can destroy us!
func _on_Asteroid_area_entered(area):
	if area.is_in_group("bullets"):
		emit_signal("asteroid_hit_by_bullet", score_award)
		_die()
	elif area.is_in_group("saucer_bullets"):
		_die()


func _die() -> void:
	Game.current_rock_count -= 1
	my_parent.create_explosion(position)

	my_parent.add_label(position, str(score_award))

	# level node will listen and create smaller asteroids on this
	# location when needed
	if my_size != 3:
		emit_signal("asteroid_exploded", position, my_size)

	queue_free()

