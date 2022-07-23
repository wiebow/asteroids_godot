extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_label(new_text) -> void:
	$ScoreLabel.text = new_text


func _on_Timer_timeout():
	queue_free()
