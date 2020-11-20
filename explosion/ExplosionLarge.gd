extends Node2D

# explosion script


# Called when the node enters the scene tree for the first time.
func _ready():
	$ExplosionPlayer.play()
	$Particles2D.emitting = true  # BUG!!!!


# remove myself from the scene once I am done
func _on_ExplosionDeleteTimer_timeout():
	queue_free()
