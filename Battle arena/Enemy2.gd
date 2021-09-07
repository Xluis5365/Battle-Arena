extends KinematicBody

onready var respawn = $respawn

var health = 100

func _ready():
	pass

func _process(delta):
	if health <= 0:
		queue_free()

func _on_respawn_timeout():
	print("im back bitches")


func _on_Enemy2_tree_exited():
	respawn.start()


func _on_Enemy3_tree_exited():
	print("dead")


func _on_Enemy4_tree_exited():
	print("dead")

func _on_Enemy5_tree_exited():
	print("dead")

func _on_Enemy6_tree_exited():
	print("dead")



