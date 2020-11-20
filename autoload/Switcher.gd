extends Node

var root = null
var current_scene = null

# this scene allows use to switch the current scene in the game
# to another scene so we can change states:
# title to play and back

# Called when the node enters the scene tree for the first time.
func _ready():
	root = get_tree().get_root()
	
	# the last item in the tree is the current scene
	# so get path to that node.
	current_scene = root.get_child(root.get_child_count() - 1)


func goto_scene(path):
	# call when all scene code has been performed
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	
	# get rid of current scene
	current_scene.free()
	
	# load the new scene
	var scene = ResourceLoader.load(path)
	
	# instance the new scene
	current_scene = scene.instance()
	
	# add it to the scene root
	root.add_child(current_scene)
	# optional
	get_tree().set_current_scene(current_scene)
	
