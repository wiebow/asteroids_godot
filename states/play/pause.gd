# pause.gd

extends CanvasLayer

# This scene must be placed in the Play scene
# and must have pausemode set to Process,
# so this code gets processed when the engine is in pause mode.

func _ready():
	$PauseDisplay.visible = false


func _process(_delta):

	# if the Play script game_over bool is set then don't
	# allow pause mode
	if get_parent().game_over:
		return

	# switch between paused and not paused mode.
	if Input.is_action_just_pressed("player_pause"):
		var new_mode = not get_tree().paused
		get_tree().paused = new_mode

		# this will also show or hide the label
		# that is attached to this pausecontrol
		$PauseDisplay.visible = new_mode
