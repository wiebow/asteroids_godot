# explosion.gd

extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$ExplosionPlayer.play()
	$Particles2D.emitting = true  # BUG!!!!

	# remove after 1 sec
	var tween : SceneTreeTween = self.create_tween()
	tween.tween_callback(self, "queue_free").set_delay(1)
