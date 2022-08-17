extends CanvasLayer

# gameover.gd
# This scene is added to the Play scene when the
# game_over signal has been emitted.
# reset() must be called after instancing to determine if the GAME OVER
# label should be shown, or the name entry should be started.

# The play scene will go to the title screen when the fadeout is finished.

# !!!
# This scene requires a Score autoload script which handles
# the loading, updating and storing and saving of the score table.

# palette: https://pico-8.fandom.com/wiki/Palette

var chars: Array = [ "a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
					 "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
					 "u", "v", "w", "x", "y", "z", ".", "-", "aa", "bb" ]

# array entries for delete and end items
const DEL := 28
const END := 29

# position in the chars array
var cursor_index := 0

# position in the name field
var name_index := 0

var entry : Array
var new_name : Array


# shortcuts to interface items

onready var no_hiscore : VBoxContainer = $MarginContainer/MainContainer/NoScoreContainer
onready var name_entry : VBoxContainer = $MarginContainer/MainContainer/NameEntryContainer

onready var register_label : Label = $MarginContainer/MainContainer/NameEntryContainer/RegisterLabel
onready var name_label: Label = $MarginContainer/MainContainer/NameEntryContainer/NewNameLabel
onready var regtime_label : Label = $MarginContainer/MainContainer/NameEntryContainer/RegiTimeLabel

onready var cursor : Sprite = $CursorSprite
onready var registration_timer : Timer = $RegisterTimer
onready var input_delay : Timer = $InputDelayTimer


# This function is called from the play scene.
func setup(player_score: int) -> void:

	input_delay.start(0.5)

	# let's see if we have scored enough to allow name entry
	if player_score > Score.get_lowest_score():
		
		# yes! show proper containers
		no_hiscore.visible = false
		name_entry.visible = true

		# set up all the stuff for name entry.
		# show the cursor and place it on the location of the A
		cursor.visible = true
		cursor.position = Vector2(291, 346)
		cursor_index = 0

		# set cursor pos in name array
		name_index = 0
		new_name = [" ", " ", " "]
#		name_registered = false

		# this returns a new entry from the hiscore list
		# for us to add the name to.
		entry = Score.add_score_to_list(player_score)

		# Update the name label to show the entry name
		_set_name_label()

		# timer counts down to end registration after passed secs
		# default is 30
		registration_timer.start(30)

	else:
		# no!
		no_hiscore.visible = true
		name_entry.visible = false
		cursor.visible = false
		
		# wait for 5 secs. Then fade out
		$WaitTimer.start(5)



func _process(_delta: float) -> void:

	# what is needed according to the container we're showing?

	# we're waitin on the fade out. no update needed	
	if not $WaitTimer.is_stopped():
		return

	if name_entry.visible:
		_handle_input()
		regtime_label.text = "regi time : " + "%02d" % int(registration_timer.time_left)
		if registration_timer.time_left == 0:
			_register_name()


# only the fire button is affected by the input delay timer.
func _handle_input() -> void:
	if Input.is_action_just_pressed("player_right"):
		cursor_index += 1
		if cursor_index == 10:
			_move_cursor(Vector2(-240+24,32))
		elif cursor_index == 20:
			_move_cursor(Vector2(-240+24,32))
		elif cursor_index == 30:
			_move_cursor(Vector2(-240+24,-64))
			cursor_index = 0
		else:
			_move_cursor(Vector2(24,0))

	elif Input.is_action_just_pressed("player_left"):
		cursor_index -= 1
		if cursor_index == -1:
			cursor_index = 29
			_move_cursor(Vector2(240-24, 64))
		elif cursor_index == 19:
			_move_cursor(Vector2(240-24, -32))
		elif cursor_index == 9:
			_move_cursor(Vector2(240-24, -32))
		else:
			_move_cursor(Vector2(-24,0))

	elif Input.is_action_just_pressed("player_down"):
		cursor_index += 10
		if cursor_index > 29:
			cursor_index -= 30
			_move_cursor(Vector2(0,-64))
		else:
			_move_cursor(Vector2(0,32))

	elif Input.is_action_just_pressed("player_up"):
		cursor_index -= 10
		if cursor_index < 0:
			cursor_index += 30
			_move_cursor(Vector2(0,64))
		else:
			_move_cursor(Vector2(0,-32))

	if Input.is_action_just_pressed("player_fire"):
		if input_delay.is_stopped():
			# after pressing fire, there is always
			# a short delay before it can be used again.
			input_delay.start(0.2)
			if cursor_index == DEL:
				_delete_letter()
			elif cursor_index == END:
				_register_name()
			else:
				_register_letter(cursor_index)


# player has hit 'end' or timer has run out
# todo: timer run out does nog trigger the fade... hmmm
func _register_name() -> void:

	# store the name field of the entry
	var entered_name: String = "" + new_name[0] + new_name[1] + new_name[2]
	entry[1] = entered_name
	
	# update UI
	cursor.visible = false
	regtime_label.visible = false
	register_label.text = "your name was registered\n"

	# save to disk!!!!
#	Score.save_scores()

	input_delay.start(20)
	# screen wipe will start when this timer has expired
	$WaitTimer.start(4)


# player hits 'rub'
func _delete_letter() -> void:
	if name_index > 0:
		name_index -= 1
	new_name[name_index] = " "
	_set_name_label()


func _register_letter(index) -> void:
	if name_index >= 3:
		return
	new_name[name_index] = chars[index]
	name_index += 1
	_set_name_label()


# set the text of the name label in the gui
func _set_name_label() -> void:
	
	# replace spaces with underscore to show
	# the letter positions in the gui
	var name_string: String = ""
	var index: int = 0
	while index < 3:
		if new_name[index] == " ":
			name_string += "_"
		else:
			name_string += new_name[index]
		index += 1

	name_label.text = "name : " +  name_string


# move the cursor sprite by passed vector amount
func _move_cursor(amount:Vector2) -> void:
	cursor.position += amount


# the play scene will react to the wipe finished signal
func _on_WaitTimer_timeout() -> void:
	Events.emit_signal("request_wipe", "fade_out")

