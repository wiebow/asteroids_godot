
# game_camera.gd

extends Camera2D

#var moving : bool = true

var max_offset : float = 4.0
var is_shaking : bool = false
var shake_radius : float
var shake_vector : Vector2


func _ready():
	# make active
	current = true
	is_shaking = false
	# position in center of screen
	position = Vector2(400,300)


func _physics_process(_delta: float) -> void:
	
#	if moving == true:
#		position.x += Global.GAME_SPEED * delta

	if is_shaking == true:
		var shake_angle:float = rand_range(0,360)
		shake_vector = Vector2(sin(shake_angle), cos(shake_angle))
		shake_vector *= shake_radius
		
		# move the camera
		offset = shake_vector
		
		shake_radius *= 0.95
		if shake_radius < 1.0:
			offset = Vector2(0,0)
			is_shaking = false


func shake(amount:float = max_offset) -> void:
	shake_radius = amount
	is_shaking = true
