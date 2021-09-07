extends MeshInstance

onready var anim_player = $AnimationPlayer
onready var camera = $Pivot/Camera
onready var raycast = $Pivot/Camera/RayCast
onready var bullet = preload("res://Bullet.tscn")
onready var blasterA = $Pivot/Camera/Hand/blasterA

const MAX_CAM_SHAKE = 0.07

var damage = 10

func fire():
	if Input.is_action_pressed("Shoot"):
		if not anim_player.is_playing():
			camera.translation = lerp(camera.translation, Vector3(rand_range(MAX_CAM_SHAKE, -MAX_CAM_SHAKE), rand_range(MAX_CAM_SHAKE, -MAX_CAM_SHAKE), 0), 0.5)
			if raycast.is_colliding():
				var b = bullet.instance()
				blasterA.add_child(b)
				b.look_at(raycast.get_collision_point(), Vector3.UP)
				b.shoot = true
				var target = raycast.get_collider()
				if target.is_in_group("enemy"):
					target.health -= damage
		anim_player.play("Assault Fire")
