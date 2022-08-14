# title.gd

# This script is the title state.
# It shows the logo and waits for a press of the fire action.
# It then requests a fade out. When the fade out has finished
# it switches to the play scene (state)

extends Node

#onready var controls = $MarginContainer/VBoxContainer/ControlsLabel
#onready var instructions = $MarginContainer/VBoxContainer/InstructionsLabel
#onready var scoretable = $MarginContainer/VBoxContainer/TableContainer
#
#onready var namecolumn = $MarginContainer/VBoxContainer/TableContainer/TableContainer/NamesColumn
#onready var scorecolumn = $MarginContainer/VBoxContainer/TableContainer/TableContainer/ScoresColumn

func _ready():
	
#	instructions.visible = true
#	controls.visible = false
#	scoretable.visible = false
#
#	# set the names and score colums texts
#
#	var list : Array = Score.get_score_entries()
#
#	# add a rainbow effect to the first entry
#	# we're adding a space to the score column to get rid of a margin problem in de gui.
#	# fixable?
#	var entry: Array = list[0]
#	namecolumn.bbcode_text = "[center][rainbow freq=5.0 sat=5 val=20]" + str(entry[1]) + "[/rainbow]\n"
#	scorecolumn.bbcode_text = "[rainbow freq=5.0 sat=5 val=20] " + str(entry[0]) + "[/rainbow]\n "
#
#	var index := 1
#	var rest_of_names := ""
#	var rest_of_scores := ""
#	while index < 10:
#		entry = list[index]
#		rest_of_names =  rest_of_names +  str(entry[1]) + "\n"
#		rest_of_scores = rest_of_scores + str(entry[0]) + "\n "
#		index += 1
#
#	namecolumn.bbcode_text = namecolumn.bbcode_text + rest_of_names + "[/center]"
#	scorecolumn.bbcode_text = scorecolumn.bbcode_text + rest_of_scores

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


func _on_TextSwitchTimer_timeout():
	pass
	
#	if controls.visible:
#		controls.visible = false
#		instructions.visible = true
#		scoretable.visible = false
#	elif instructions.visible:
#		controls.visible = false
#		instructions.visible = false
#		scoretable.visible = true
#	elif scoretable.visible:
#		controls.visible = true
#		instructions.visible = false
#		scoretable.visible = false
