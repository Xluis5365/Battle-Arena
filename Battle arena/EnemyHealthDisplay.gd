extends Node2D


onready var healthbar = $Healthbar

func _ready():
	hide()
	if get_parent() and get_parent().get("health"):
		healthbar.max_value = get_parent().health

func _process(delta):
	global_rotation = 0
	
func update_healthbar(value):
	if value < healthbar.max_value:
		show()
	healthbar.value = value
