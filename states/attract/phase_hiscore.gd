extends Node2D

# This scipt fills the columns when the scene is started.

onready var namecolumn : RichTextLabel = $VBoxContainer/HBoxContainer/NameColumn
onready var scorecolumn : RichTextLabel = $VBoxContainer/HBoxContainer/ScoreColumn


# Called when the node enters the scene tree for the first time.
func _ready():
	
	# set the names and score colums texts

	var list : Array = Score.get_score_entries()

	# add a rainbow effect to the first entry
	# we're adding a space to the score column to get rid of a margin problem in de gui.
	# fixable?
	var entry: Array = list[0]
	namecolumn.bbcode_text = "[center][rainbow freq=5.0 sat=5 val=20]" + str(entry[1]) + "[/rainbow]\n"
	scorecolumn.bbcode_text = "[rainbow freq=5.0 sat=5 val=20] " + str(entry[0]) + "[/rainbow]\n "

	var index := 1
	var rest_of_names := ""
	var rest_of_scores := ""
	while index < 10:
		entry = list[index]
		rest_of_names =  rest_of_names +  str(entry[1]) + "\n"
		rest_of_scores = rest_of_scores + str(entry[0]) + "\n "
		index += 1

	namecolumn.bbcode_text = namecolumn.bbcode_text + rest_of_names + "[/center]"
	scorecolumn.bbcode_text = scorecolumn.bbcode_text + rest_of_scores
	
