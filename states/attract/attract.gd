extends Node

# This script will cycle through the attract phases.
# For each cycle it will start the fade tweens.
# The phase must have a Node2D as its root.

const ATTRACT_DELAY := 10

onready var attract_phases : Array = [$PhaseHiscore, $PhaseControls, $PhaseInstructions]
var phases_index := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# this tween will call the _cycle method every ATTRACT_DELAY seconds
	var tween: SceneTreeTween = self.create_tween().set_loops()
	tween.tween_callback(self, "_cycle").set_delay(ATTRACT_DELAY)
	
	# set the modulate alpha to 0 for each phase
	for i in attract_phases.size():
		attract_phases[i].modulate = Color(1, 1, 1, 0)
	
	# enable the first attract phase
	_cycle()
	

func _cycle() -> void:
	var phase = attract_phases[phases_index]
	var tween: SceneTreeTween = phase.create_tween()
	tween.tween_property(phase, "modulate", Color(1, 1, 1, 1.0), 1.0)
	tween.tween_property(phase, "modulate", Color(1, 1, 1, 0.0), 1.0).set_delay(ATTRACT_DELAY - 2)

	# prepare for the next phase
	
	phases_index += 1
	if phases_index > attract_phases.size()-1:
		phases_index = 0

