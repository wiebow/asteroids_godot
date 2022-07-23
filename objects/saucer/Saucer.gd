
# saucer game object script
# a saucer is spawned by the Level node.
# and added just like an asteroid.

extends "res://objects/BaseObject.gd"

# saucer can send these signals.
signal saucer_hit_player()
signal saucer_hit_bullet()
signal saucer_hit_asteroid()

# parent of this saucer is the current scene.
onready var bulletsound = $BulletSoundPlayer

var speed:float = 100
var fire_delay:float = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	#place just outside screen
	position = Vector2(-16, -16)


#func _process_physics(delta) -> void:
#	pass


# called when a new direction is needed
# the timer is
func _on_DirectionChangeTimer_timeout():

	# set random move direction
	velocity = Vector2( rand_range(-1.0, 1.0), rand_range(-1.0, 1.0) )
	velocity = velocity.normalized()
	velocity *= speed + rand_range(-25.0, 25.0)

	# update the move speed so the saucer travels faster over time
	speed = min(200, speed + 4)


# fire a bullet when the timer has expired.
func _on_FireDelayTimer_timeout():
	_create_saucer_bullet()

	# update the fire delay, so the saucer fires faster over time
	# saucer is not alive a long time, so speed up quickly
	fire_delay = max(0.2, fire_delay * 0.8)
	$FireDelayTimer.wait_time = fire_delay


func _create_saucer_bullet() -> void:
	var scene = load("res://objects/bullets/SaucerBullet.tscn")
	var bullet = scene.instance()
	# set in position and give random direction
	bullet.initialize( position, rand_range(0, 360) ) #rotation_degrees )
	my_parent.add_child(bullet)
	bulletsound.play()


# something enters the Saucer collision area.
# See what it is and send the proper signal.
# We only check groups that can destroy us.
# Die if needed depending on the thing we collided with
func _on_Saucer_area_entered(area):
	if area.is_in_group("asteroids"):
		emit_signal("saucer_hit_asteroid")
		_die()
	elif area.is_in_group("player"):
		emit_signal("saucer_hit_player")
		_die()
	elif area.is_in_group("bullets"):
		emit_signal("saucer_hit_bullet")

		my_parent.add_label(position, "1000")
		_die()


func _die():
	Game.current_saucer_count -= 1
	my_parent.create_explosion(position)
	queue_free()

