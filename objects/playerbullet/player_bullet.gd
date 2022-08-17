# player_bullet.gd

extends "res://objects/base_object.gd"

# The playerbullet is a simple object that moves in a direction
# and dies after a time period.
# It does NOT check collisions. The objects that can be
# hit do the scanning, and also delete the bullet.
# This means that monitoring on the Area2D is turned off.

const SPEED : int = 400

var life : int

# Called when the node enters the scene tree for the first time.
func _ready():
	life = 80


func _physics_process(_delta) -> void:
	# update life and remove self when life has run out.
	life -= 1 # * delta
	if life == 0:
		queue_free()


func initialize( new_position: Vector2, new_degrees: float ) -> void:
	position = new_position
	rotation_degrees = new_degrees

	# move it!
	velocity = Vector2(0, -SPEED).rotated(deg2rad(rotation_degrees))

