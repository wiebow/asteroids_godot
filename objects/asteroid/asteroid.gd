# asteroid.gd

extends "res://objects/base_object.gd"

# award for player
var points : int
# angle changes this amount per frame
var rotation_dir := 0
# 1 is big, 2 is medium, 3 is small
var my_size : int


# Called when the node enters the scene tree for the first time.
func _ready():
	# give it a nice random color
	$AsteroidSprite.modulate = Color(
		rand_range(0.4, 1.0),
		rand_range(0.5, 1.0),
		rand_range(0.4, 1.0), 1.0
		)


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
			$ObjectCollision.apply_scale(Vector2(9.0, 9.0))
			points = 100
		2:
			$AsteroidSprite.play("normal")
			rotation_dir = rand_range(-2, 2)
			$ObjectCollision.apply_scale(Vector2(5.0, 5.0))
			points = 150
		3:
			$AsteroidSprite.play("small")
			rotation_dir = rand_range(-4, 4)
			$AsteroidSprite.apply_scale((Vector2(0.8, 0.8)))
			$ObjectCollision.apply_scale(Vector2(2.0, 2.0))
			points = 300

	# set velocity according to size
	set_velocity(randi() % 25 + (size * 30))


func set_velocity(speed) -> void:
	# rocks always go into a random direction
	velocity = Vector2(rand_range(-1, 1), rand_range(-1, 1))
	velocity *= speed


# check the collisions that can harm this asteroid.
func _on_Asteroid_area_entered(area):
	if area.is_in_group("bullets"):
		Events.emit_signal("points_awarded", points, position)
		area.queue_free()
		_die()

	# the saucer can also destroy asteroids with its bullets
	# robbing you of points!
	elif area.is_in_group("saucer_bullets"):
#		Events.emit_signal("points_awarded", points)
		area.queue_free()
		_die()


# get rid of this asteroid. and generate new ones if needed
func _die() -> void:
	Events.emit_signal("create_explosion", position)

	# do not generate asteroids if we are already of the smallest size.
	if my_size != 3:
		Events.emit_signal("create_asteroid", position, my_size + 1)

	queue_free()

