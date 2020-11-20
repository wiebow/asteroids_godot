extends Node

# this script contains game variables
# and some code to act on these variables

var game_over:bool
var current_level:int
var extra_life_given:bool
const extra_life_treshold:int = 25000

var current_saucer_count:int
const saucer_spawn_delay:int = 15 # seconds

var start_rocks:int
var current_rock_count:int
# limiter on the difficulty
const max_start_rocks:int = 10
# rocks split in this many new rocks
var rock_split_count:int
# max amount of splits. limited on the difficulty
const max_rock_split_count:int = 7

var player_spare_lives:int
var player_score:int
var player_warps:int
var hi_score:int


# when the level starts, and after the death of a saucer,
# the choice is made to add a new sacuer. If yes, a
# generate timer is set to a value between 20-40 seconds.
var generate_saucer:bool


# resets all the game variables to start a NEW game
func reset_all() -> void:
	game_over = false
	extra_life_given = false

	player_spare_lives = 2
	player_score = 0
	player_warps = 3

	current_level = 1
	current_rock_count = 0
	rock_split_count = 2
	start_rocks = 3

	current_saucer_count = 0

