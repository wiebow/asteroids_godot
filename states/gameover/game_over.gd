extends Node2D

onready var timer = $GameOverControl/GameOverTimer
var ready:bool = false

# hide this control when we enter the game
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func enable() -> void:
	visible = true
	timer.start()


func is_ready() -> bool:
	return ready


# if this is true, then we can press fire to continue.
func _on_GameOverTimer_timeout():
	ready = true
