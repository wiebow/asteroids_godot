# sauder.gd

extends "res://objects/base_object.gd"

# a saucer is spawned by the Play node.
# and added just like an asteroid.

var speed := 100.0
var fire_delay := 4.0

# parent of this saucer is the current scene.
onready var bulletsound = $BulletSoundPlayer as AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# place just outside screen
	# in a corner so it can appear anywhere after a wrap.
	position = Vector2(-16, -16)


# called when a new direction is needed
func _on_DirectionChangeTimer_timeout():

	# set random move direction
	velocity = Vector2( rand_range(-1.0, 1.0), rand_range(-1.0, 1.0) )
	velocity = velocity.normalized()
	velocity *= speed + rand_range(-25.0, 25.0)

	# update the move speed so the saucer travels faster over time
	# next time the direction changes.
	speed = clamp(speed, 200, speed + 4)


# fire a bullet when the timer has expired.
func _on_FireDelayTimer_timeout():
	Events.emit_signal("create_saucer_bullet", position)
	bulletsound.play()

	# update the fire delay, so the saucer fires faster over time
	# saucer is not alive a long time, so speed up quickly
	fire_delay = max(0.2, fire_delay * 0.8)
	$FireDelayTimer.wait_time = fire_delay


# we only look at areas (objects) that can kill us
func _on_Saucer_area_entered(area):
	if area.is_in_group("asteroids"):
		Events.emit_signal("create_explosion", position)
		self.queue_free()

	elif area.is_in_group("bullets"):
		Events.emit_signal("create_explosion", position)
		Events.emit_signal("points_awarded", 1000, position)
		area.queue_free()
		self.queue_free()

