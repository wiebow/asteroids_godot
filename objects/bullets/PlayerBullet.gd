
# player bullet script

extends "res://objects/BaseObject.gd"


const SPEED : int = 400
var life : float

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


func _on_PlayerBullet_area_entered(area):
	if area.is_in_group("asteroids"):
		queue_free()
	elif area.is_in_group("saucer"):
		queue_free()

