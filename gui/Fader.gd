extends CanvasLayer


signal fade_finished

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func start_fadein() -> void:
	$FadeRect/FadeAnimation.play("fade_in")

func start_fadeout() -> void:
	$FadeRect/FadeAnimation.play("fade_out")


func _on_FadeAnimation_animation_finished(anim_name):
	emit_signal("fade_finished", anim_name)
