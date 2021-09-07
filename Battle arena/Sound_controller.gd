extends Spatial


func _ready():
	Spatial.sound_controller = self 
	
func _exit_tree():
	Spatial.sound_controller = null
