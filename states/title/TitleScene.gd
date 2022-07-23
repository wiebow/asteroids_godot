extends Node

func _ready() -> void:
	_generate_title_rocks()
	$Fader.start_fadein()


func _process(_delta) -> void:
	if Input.is_action_just_pressed("player_fire"):
		$Fader.start_fadeout()


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


# called when the fader is finished
func _on_Fader_fade_finished(anim_name):
	Switcher.goto_scene("res://states/play/PlayScene.tscn")
	
