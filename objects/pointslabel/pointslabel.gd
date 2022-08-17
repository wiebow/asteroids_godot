# pointslabel.gd

extends Node2D

# a simple scene to place text on the playfield


func initialize(new_text: int, new_position: Vector2) -> void:
	position = new_position
	$ScoreLabel.text = String(new_text)

	# remove after 1 sec
	var tween : SceneTreeTween = self.create_tween()
	tween.tween_callback(self, "queue_free").set_delay(1)
