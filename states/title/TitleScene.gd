extends Node

func _ready() -> void:
	_generate_title_rocks()
	$Fader/FadeRect/FadeAnimation.play("fade_in")


func _process(_delta) -> void:
	if Input.is_action_just_pressed("player_fire"):
		$Fader/FadeRect/FadeAnimation.play("fade_out")
		$FadeWaitTimer.start()


# called when the fade timer has run out
#func _on_FadeTimer_timeout():
#	Global.goto_scene("res://states/play/PlayScene.tscn")


# specific version of generate rocks for title screen
# to have a bit more variety
func _generate_title_rocks() -> void:
	var rocks = 0
	var scene = load("res://objects/asteroid/Asteroid.tscn")

	while rocks < 13:
		var asteroid = scene.instance()
		asteroid.initialize(randi()%3+1) # random integer from 1 to 3
		asteroid.set_position( Vector2(	rand_range(0, 800),
										rand_range(0, 600)))

		self.add_child(asteroid)
		rocks += 1


func _on_FadeWaitTimer_timeout():
	Switcher.goto_scene("res://states/play/PlayScene.tscn")
