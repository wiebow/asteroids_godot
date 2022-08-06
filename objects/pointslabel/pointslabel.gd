
# pointslabel.gd
# a simple scene to place a label on the playfield

extends Node2D


func initialize(new_text: int, new_position: Vector2) -> void:
	position = new_position
	$ScoreLabel.text = String(new_text)


func _on_Timer_timeout():
	queue_free()
