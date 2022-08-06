# Wipe.gd

# This scene does a screen wipe using a rectangle that is
# faded in or out.
# The animationplayer has two animations: fade_in and fade_out
# These names have to be used when firing the request signal.

extends Node

onready var anim: AnimationPlayer = $WipeRect/WipeAnimation


func _ready() -> void:
	Events.connect("request_wipe", self, "_on_wipe_requested")


func _on_wipe_requested(anim_name: String) -> void:
	anim.play(anim_name)


# list for this signal when you want to react to a finished fade
func _on_FadeAnimation_animation_finished(anim_name: String) -> void:
	Events.emit_signal("wipe_finished", anim_name)
