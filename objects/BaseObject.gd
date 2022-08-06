extends Area2D

# base gameobject script
# all scenes derived from this will be able to use these functions
# they must extend with : extend "../BaseObject.gd"

# main goal is to standardise the screen wrap for all objects in one go.

# variable visible in de godot editor
export var wrap_buffer : int = 0

var screen_size : Vector2
var velocity : Vector2
var my_parent = null

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	my_parent = get_node("../")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += velocity * delta
	_check_wrap()


# wrap object position when moving outside the viewport
func _check_wrap() -> void:
	if position.x < -wrap_buffer:
		position.x = screen_size.x + wrap_buffer
	elif position.x > screen_size.x + wrap_buffer:
		position.x = -wrap_buffer

	if position.y < -wrap_buffer:
		position.y = screen_size.y + wrap_buffer
	elif position.y > screen_size.y + wrap_buffer:
		position.y = -wrap_buffer

