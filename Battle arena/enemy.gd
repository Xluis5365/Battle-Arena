extends KinematicBody

var health =  100
onready var nav = get_parent()
onready var player = $"../../Player3D"

var path = []
var path_node = 0

var speed = 10

func _ready():
	pass

func _process(delta):
	if health <= 0:
		queue_free()
		
func _physics_process(delta):
	if path_node < path.size():
		var direction = (path[path_node] - global_transform.origin)
		if direction.length() < 1:
			path_node += 1
		else:
			move_and_slide(direction.normalized() * speed, Vector3.UP)
			
func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node = 0

func _on_Timer_timeout():
	move_to(player.global_transform.origin)
