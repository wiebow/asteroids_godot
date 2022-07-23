extends Node

# camera

# this script can control the canvas of the root viewport
# allowing it to shake and/or move.
# move or follow an object is not yet implemented

# use this on the Root node of the play scene.
# I call the node View as it does affect the view.
# o View
#   o Level
#     + Player
#     + otherstuff
#     + .....

# how much can the screen shake?
var max_offset:float = 4.0
var current_offset:float = 0
var is_shaking:bool

func _ready():
	pass

func _process(_delta):

	if is_shaking == true:
		var move:Vector2 = Vector2(0.0, 0.0)

		current_offset -= 0.25
		if current_offset < 0:
			is_shaking = false

		# get/copy the canvas transform matrix
		var canvas_transform = get_viewport().get_canvas_transform()
		# get a new move value and set it
		move = Vector2(rand_range(-max_offset, max_offset),
									rand_range(-max_offset, max_offset))
		canvas_transform[2] = move
		# set the canvas transform matrix with our modified version
		get_viewport().set_canvas_transform(canvas_transform)


func _on_Level_shake():
	# multiple shake signals result in longer shake
	current_offset = max_offset
	is_shaking = true
