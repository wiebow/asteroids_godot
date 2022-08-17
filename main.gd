# main.gd

extends Node

# Main scene that will hold all the other game scenes.
# See the scene_switcher autoload script!
# Also does initial setup in the _ready function.

func _ready() -> void:
	
	randomize()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	# scores have been loaded because of the autoload script,
	# so update the gui.
	Events.emit_signal("gui_change_hiscore", Score.get_hi_score())
