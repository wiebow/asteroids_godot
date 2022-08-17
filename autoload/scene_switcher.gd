# scene_switcher.gd

extends Node

# Add this script as an autoload script in the project settings.
# This script allows you to swap out the current scene
# for another scene. In this way, the game can change state.

# The setup assumes that when the game starts, the active scene
# is located at "/root/Main/Title". (being in the title state)

# When a fade_out (using Wipe) has finished, you can call
# goto_scene to select the new scene. This new scene should
# call a fade_in.


var current_scene = null

func _ready():
	# Our game always starts with a Title scene in the Main node,
	# so we use that path for our default scene (state)
	current_scene = get_node("/root/Main/Title")


func goto_scene(path):

	# wait for the call until code in the current scene has been
	# executed.
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):

	# get rid of current scene
	current_scene.free()

	# instance the new scene and add it under the Main node.
	var scene = ResourceLoader.load(path)
	current_scene = scene.instance()
	var parent = get_node("/root/Main")
	parent.add_child(current_scene)

	# optional
#	get_tree().set_current_scene(current_scene)
