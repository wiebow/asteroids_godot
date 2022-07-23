extends Node

# As this script is attaced to the Main node, it is only performed
# once, when the game starts.
# So, put stuff here that only has to be performed on game startup.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
