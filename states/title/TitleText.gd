extends CanvasLayer

onready var inst = $InstructionLabel
onready var keys = $KeyControlLabel
onready var joys = $JoyControlLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	inst.visible = true
	keys.visible = false
	joys.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LabelCycleTimer_timeout():
	
	#cycle through the labels
	if inst.visible == true:
		inst.visible = false
		keys.visible = true
	elif keys.visible == true:
		keys.visible = false
		joys.visible = true
	elif joys.visible == true:
		joys.visible = false
		inst.visible = true
