extends Spatial

var damage = 10

var gravity = -30
var max_speed = 8
var mouse_sensitivity = 0.0025 # radian/pixel
var jump_speed = 12

var velocity = Vector3()
var jump = false

const SWAY = 30
const MAX_CAM_SHAKE = 0.07

onready var anim_player = $AnimationPlayer
onready var camera = $Pivot/Camera
onready var raycast = $RayCast
onready var bulletshotgun = preload("res://ShotgunBullet.tscn")
onready var blasterA = $Pivot/Camera/Hand/blasterA
onready var guncam = $Pivot/Camera/Hand/ViewportContainer/Viewport/GunCam
onready var machinegun = $Pivot/Camera/Hand/MachineGun
onready var Shotgun = $Pivot/Camera/Hand/Shotgun

func fire():
	if Input.is_action_pressed("Shoot"):
		if not anim_player.is_playing():
			if raycast.is_colliding():
				var b = bulletshotgun.instance()
				Shotgun.add_child(b)
				b.look_at(raycast.get_collision_point(), Vector3.UP)
				b.shoot = true
				var target = raycast.get_collider()
				if target.is_in_group("enemy"):
					target.health -= damage
		anim_player.play("Assault Fire")
