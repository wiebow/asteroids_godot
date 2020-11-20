extends Control

# This scene must be placed in the Play scene
# and must have the Process mode set on pausemode
# so this code gets processed when the engine is in pause mode.

func _ready():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	# switch between paused and not paused mode.
	if Input.is_action_just_pressed("game_pause"):
		var new_mode = not get_tree().paused
		get_tree().paused = new_mode
		
		# this will also show or hide the label
		# that is attached to this pausecontrol
		visible = new_mode

