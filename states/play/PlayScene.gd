
# play scene script
# this is the "level" or "world" we play in

# nodes added to this node can use its method
# by using my_parent.method

extends Node

onready var start_sound:AudioStreamPlayer = $LevelStartSound
onready var fader = $Fader
onready var player = $Player
onready var gui = $GUI
onready var saucer_timer = $SaucerCreationTimer

# signal to send when we want the screen to shake.
signal shake


# Called when this node enters the scene tree for the first time.
func _ready():
	Game.reset_all()
	gui.update_all()
	player.reset()
	_start_level()
	fader.start_fadein()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	if Game.game_over == true:
		if $GameOver/GameOverControl.is_ready():
			# more this to the game over scene we add to the play
			# scene when dead
			if Input.is_action_just_pressed("player_fire"):
				_goto_titlescreen()
		return

	# advance a level if we've gotten rid of all asteroids
	# and any saucers
	if Game.current_rock_count == 0 and Game.current_saucer_count == 0:
		_advance_level()
		return

	if Input.is_action_just_pressed("game_quit"):
		_goto_titlescreen()


func _goto_titlescreen() -> void:
	fader.start_fadeout()


func _start_level():
	_generate_start_asteroids()
	start_sound.play()


func _advance_level() -> void:

	# give the player an additional warp to a max of 5 warps.
	Game.player_warps = min(5, Game.player_warps + 1)
	gui.update_warps()

	# give the player 500 points and 500 for each
	# level. So 1000 for level 2, 1500 for level 3, etc.
	add_player_points(500 + Game.current_level*500)

	# advance the start rocks count
	Game.start_rocks = min(Game.max_start_rocks,
						   Game.start_rocks + 1)

	# advance the split count
	Game.rock_split_count = min(Game.max_rock_split_count,
								Game.rock_split_count + 1)

	# advance level counter
	Game.current_level += 1
	gui.update_level()

	# reset saucer count and start the spawn timer
	Game.current_saucer_count = 0
	saucer_timer.start(Game.saucer_spawn_delay)

	_start_level()


func _generate_saucer() -> void:
	var scene = load("res://objects/saucer/Saucer.tscn")
	var saucer = scene.instance()
	add_child(saucer)
	Game.current_saucer_count += 1

	# connect saucer signals to methods in this script (self)
	saucer.connect("saucer_hit_player", self, "_on_saucer_hit_player")
	saucer.connect("saucer_hit_bullet", self, "_on_saucer_hit_bullet")


func _generate_start_asteroids() -> void:
	var count = 0
	while count < Game.start_rocks:
		var asteroid = _create_asteroid()
		asteroid.initialize(1) # big ones
		asteroid.set_position(Vector2(rand_range(0, 800),
									  rand_range(0, 600)))
		count += 1


func _create_asteroid():
	var scene = load("res://objects/asteroid/Asteroid.tscn")
	var asteroid = scene.instance()

	# connect asteroid signals to method in this script (self)
	asteroid.connect("asteroid_exploded", self, "_on_asteroid_explosion")
	asteroid.connect("asteroid_hit_by_bullet", self, "_on_asteroid_hit")

	add_child(asteroid)
	Game.current_rock_count += 1
	return asteroid


func create_explosion(pos:Vector2):
	# generate explosion
	var scene = load("res://explosion/ExplosionLarge.tscn")
	var expl = scene.instance()
	expl.set_position(pos)
	add_child(expl)
	emit_signal("shake")


func add_player_points(amount) -> void:

	Game.player_score += amount
	gui.update_player_score()
	Game.hi_score = max(Game.player_score, Game.hi_score)
	gui.update_hi_score()

	# check if extra life is awarded.
	if Game.extra_life_given == false and Game.player_score >=  Game.extra_life_treshold:
		Game.extra_life_given = true
		Game.player_spare_lives += 1
		$ExtraLifeSound.play()
		gui.update_lives()


# generate_split_rocks is called in an area inspection loop in Asteroid.gd.
# As we cannot add new areas when we're inspecting areas,
# we need to generate rocks AFTER the scene has been processed.
func generate_split_rocks( position: Vector2, size:int ) -> void:
	call_deferred("_deferred_generate_split_rocks", position, size)


func _deferred_generate_split_rocks( pos:Vector2, size:int ):
	var rocks = 0
	while rocks < Game.rock_split_count:
		var asteroid = _create_asteroid()
		asteroid.initialize(size)
		asteroid.set_position(pos)
		rocks += 1


# adds a flashing label to the scene
# for instance, to indicate score.
func add_label(position:Vector2, string):
	var scene = load("res://objects/ScoreFlash.tscn")
	var label = scene.instance()
	label.set_position(position)
	label.set_label(string)
	add_child(label)


# signals sent from level objects are handled here.

# connected to in code.
func _on_saucer_hit_player() -> void:
	player.die()


# connected to in code.
func _on_saucer_hit_bullet() -> void:
	add_player_points(1000)


# connected to in code.
func _on_asteroid_explosion( pos:Vector2, size:int):

	# generate additional rocks if the size is not 3
	# 3 is the smallest rock. 1 = the biggest
	if size != 3:
		generate_split_rocks( pos, size + 1)


# connected to in code.
func _on_asteroid_hit( score ) -> void :
	add_player_points(score)


func _on_Player_player_warp():
	gui.update_warps()


func _on_Player_player_died():
	gui.update_lives()


func _on_Player_game_over():
	if Game.game_over == false:
		Game.game_over = true

		# activate the game over control
		$GameOver/GameOverControl.enable()
		# play game over sound
		$GameOverBoom.play()


# called when the saucer creation timer has expired
# we then see if we want to actually create a saucer
# no saucer is created when there already is one
func _on_SaucerCreationTimer_timeout():

	# restart timer, with a bit of randomness
	saucer_timer.start(Game.saucer_spawn_delay + randi() % 5 )

	if Game.current_saucer_count:
		return
	_generate_saucer()


func _on_Fader_fade_finished(anim_name):
	if anim_name == "fade_out":
		Switcher.goto_scene("res://states/title/TitleScene.tscn")
