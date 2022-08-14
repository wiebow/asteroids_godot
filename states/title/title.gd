# title.gd

# This script is the title state.
# It shows the logo and waits for a press of the fire action.
# It then requests a fade out. When the fade out has finished
# it switches to the play scene (state)

extends Node

func _ready():

	# connect to and send signals

	Events.connect("wipe_finished", self, "_on_wipe_finished")
	Events.emit_signal("gui_stats_visible", false)
	Events.emit_signal("request_wipe", "fade_in")
	
	# create all those lovely title asteroids
	var rocks = 0
	var scene = load("res://objects/asteroid/Asteroid.tscn")
	var parent_node = get_node("AsteroidNode")

	while rocks < 11:
		var asteroid = scene.instance()
		asteroid.initialize(randi()%3+1) # random integer from 1 to 3
		asteroid.set_position( Vector2(	rand_range(0, 800),
										rand_range(0, 600)))

		parent_node.add_child(asteroid)
		rocks += 1


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("player_fire"):
		Events.emit_signal("request_wipe", "fade_out")


func _on_wipe_finished(name) -> void:
	if name == "fade_out":
		SceneSwitcher.goto_scene("res://states/play/play.tscn")
