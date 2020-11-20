
# game GUI script

extends Node

# this script expects that there is a Game pre-load script,
# which contains the globals player_score, hi_score, player_warps, etc.

onready var score = $CanvasLayer/MarginContainer/VBoxContainer/ScoreContainer/Playerscore
onready var hi_score = $CanvasLayer/MarginContainer/VBoxContainer/ScoreContainer/Highscore
onready var warps = $CanvasLayer/MarginContainer/VBoxContainer/StatsContainer/WarpContainer/WarpCounter
onready var level = $CanvasLayer/MarginContainer/VBoxContainer/StatsContainer/LevelCounter
onready var lives = $CanvasLayer/MarginContainer/VBoxContainer/StatsContainer/LifeContainer/LifeCounter


# these function only update the counters
func update_all() -> void:
	update_player_score()
	update_hi_score()
	update_warps()
	update_level()
	update_lives()

# score.text = "%06d" % 1234
# gives 001234
# this is how to pad strings with 0's

func update_player_score() -> void:
	score.text = "%06d" % Game.player_score


func update_hi_score() -> void:
	hi_score.text = "%06d" % Game.hi_score


func update_warps() -> void:
	warps.text = "%02d" % Game.player_warps


func update_level() -> void:
	level.text = "L=" + "%02d" % Game.current_level


func update_lives() -> void:
	lives.text = "%02d" % Game.player_spare_lives

