extends RigidBody

var shoot = false

const speed = 10
const Damage = 30

func _ready():
	set_as_toplevel(true)
	
func _physics_process(delta):
	if shoot:
		apply_impulse(transform.basis.z, -transform.basis.z * speed)


func _on_Area_body_entered(body):
	if body.is_in_group("enemy"):
		body.health -= Damage
		queue_free()
	else:
		queue_free()
