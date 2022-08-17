# gui.gd

extends CanvasLayer

# This script updates the gui elements according to the values
# passed by the connected signals.

onready var score: Label = $MarginContainer/VBoxContainer/ScoreContainer/Playerscore
onready var hi_score: Label = $MarginContainer/VBoxContainer/ScoreContainer/Highscore
onready var level: Label = $MarginContainer/VBoxContainer/StatsContainer/LevelCounter
onready var lives: Label = $MarginContainer/VBoxContainer/StatsContainer/LifeContainer/LifeCounter
onready var warps: Label = $MarginContainer/VBoxContainer/StatsContainer/WarpContainer/WarpLabel
onready var stats: HBoxContainer = $MarginContainer/VBoxContainer/StatsContainer


# Connect signals to local functions.
# These signals need to be defined in the autoload scipt Events.
func _ready() -> void:
	Events.connect("gui_stats_visible", self, "_on_stats_visible")
	Events.connect("gui_change_score", self, "_on_score_update")
	Events.connect("gui_change_hiscore", self, "_on_hiscore_update")
	Events.connect("gui_change_level", self, "_on_level_update")
	Events.connect("gui_change_lives", self, "_on_lives_update")
	Events.connect("gui_change_warps", self, "_on_warps_update")


# local functions that are connected to the signals in _ready()

func _on_stats_visible(value: bool) -> void:
	stats.visible = value


func _on_score_update(value: int) -> void:
	score.text = "%06d" % value


func _on_hiscore_update(value: int) -> void:
	hi_score.text = "%06d" % value


func _on_level_update(value: int) -> void:
	level.text = "L=" + "%02d" % value


func _on_lives_update(value: int) -> void:
	lives.text = "%02d" % value


func _on_warps_update(value: int) -> void:
	warps.text = "%02d" % value
