# events.gd
# autoload script. See Project Settings.

extends Node

# This script facilitates the signals inside the game.
# As this script is an autoload, it is available to all scenes in the project.
# This means that the singals can be fired by every scene, and every scene
# in the project can subsbcribe to any signal in this script.

# fire a signal: Events.emit_signal("points_awarded", 2)
# Subscribe to signal in the scene _ready() function:
# Events.connect("points_awarded", self, "_local_function_name")

# So, each game event must be setup in this script file.
# The events change per game. Here are some basic events:

# GUI signals
# The GUI scene subscribes to these to update onscreen counters
signal gui_change_lives(value)
signal gui_change_score(value)
signal gui_change_hiscore(value)
signal gui_change_level(value)
signal gui_change_warps(value)
signal gui_stats_visible(bool_value)

# screen signals
signal request_wipe(name)
signal wipe_finished(name)
signal request_shake()

# Game event signals
# The play state (scene) should subscribe to these.
signal create_asteroid(position, size, count)
signal create_bullet(position, direction)
signal create_saucer_bullet(position, direction)
signal create_explosion(position)

signal points_awarded(amount, position)
signal level_clear()
signal game_over()

