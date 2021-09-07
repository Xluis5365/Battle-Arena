extends KinematicBody

var damage = 10
var damageshotgun = 15
var shotgunspread = 0.5
var lmgdamage = 20
var sniperdamage = 100

var normal_speed = 8
var gravity = -30
var max_speed = 8
var mouse_sensitivity = 0.0025 # radian/pixel
var jump_speed = 12
var health = 100

export var spawnpoint = Vector3(3.404, 0.878, 7.249)

export var fire_sound: AudioStream

var running_speed = 12

var velocity = Vector3()
var jump = false

const SWAY = 30
const MAX_CAM_SHAKE = 0.03

onready var b_decal = preload("res://Bulletdecal.tscn")
onready var particle = $Pivot/Camera/Hand/BlasterA/Muzzleflashsmg

onready var particleshotgun = $Pivot/Camera/Hand/ShotgunHand/muzzleflashshotgun

onready var anim_player = $AnimationPlayer
onready var camera = $Pivot/Camera
onready var raycast = $Pivot/Camera/RayCast
onready var bullet = preload("res://Bullet.tscn")
onready var blasterA = $Pivot/Camera/Hand/BlasterA/blasterA
onready var machinegun = $Pivot/Camera/Hand/LmgHand/MachineGun
onready var Shotgun = $Pivot/Camera/Hand/ShotgunHand/Shotgun
onready var bulletshotgun = preload("res://ShotgunBullet.tscn")
onready var ray_container_for_shotgun = $Pivot/Camera/Hand/Raycontainerforshotgun
onready var lmgbullet = preload("res://Lmgbullet.tscn")
onready var muzzle = preload("res://muzzle.tscn")
onready var Sniper = $Pivot/Camera/Hand/SniperHand/Sniper

onready var fire_sound_player = $AudioStreamPlayer3D

onready var guncam = $Pivot/Camera/ViewportContainer/Viewport/Guncam

var current_weapon = 1

func running():
	if Input.is_action_pressed("Shift") and is_on_floor():
		max_speed = normal_speed
	elif Input.is_action_just_released("Shift"):
		max_speed = running_speed

func get_input(): #movement
	jump = false
	if Input.is_action_just_pressed("Jump"):
		jump = true
	var input_dir = Vector3()
	if Input.is_action_pressed("Forward"): 
		input_dir += -camera.global_transform.basis.z
	if Input.is_action_pressed("Back"):
		input_dir += camera.global_transform.basis.z
	if Input.is_action_pressed("Right"):
		input_dir += camera.global_transform.basis.x
	if Input.is_action_pressed("Left"):
		input_dir += -camera.global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir

func _unhandled_input(event): #camera
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)

func weapon_select(): #weapon
	if Input.is_action_just_pressed("weapon1"):
		current_weapon = 1
	elif Input.is_action_just_pressed("weapon2"):
		current_weapon = 2
	elif Input.is_action_just_pressed("weapon3"):
		current_weapon = 3
	elif Input.is_action_just_pressed("weapon4"):
		current_weapon = 4
	
	if current_weapon == 1:
		blasterA.visible = true
	else:
		blasterA.visible = false
	if current_weapon == 2:
		machinegun.visible = true
	else:
		machinegun.visible = false
 
	if current_weapon == 3:
		Shotgun.visible = true
	else:
		Shotgun.visible = false
	
	if current_weapon == 4:
		Sniper.visible = true
	else:
		Sniper.visible = false
	
func _ready():
	randomize()
	for r in ray_container_for_shotgun.get_children():
		r.cast_to.x = rand_range(shotgunspread, -shotgunspread)
		r.cast_to.y = rand_range(shotgunspread, -shotgunspread)

func fire():
	if Input.is_action_pressed("Shoot"):
		if current_weapon==1:
			fire_smg()
		elif current_weapon==2:
			fire_lmg()
		elif current_weapon==3:
			fire_shotgun()
		elif current_weapon==4:
			fire_sniper()

func fire_shotgun():
	if Input.is_action_just_pressed("Shoot"):
		for r in ray_container_for_shotgun.get_children():
			r.cast_to.x = rand_range(shotgunspread, -shotgunspread)
			r.cast_to.y = rand_range(shotgunspread, -shotgunspread)
			particleshotgun.emitting = true
			if r.is_colliding():
					var bullet = bulletshotgun.instance()
					Shotgun.add_child(bullet)
					bullet.look_at(raycast.get_collision_point(), Vector3.UP)
					bullet.shoot = true
					var target = raycast.get_collider()
					if target.is_in_group("Enemy2"):
						target.health -= damageshotgun
					else:
						pass
					var hole = b_decal.instance()
					r.get_collider().add_child(hole)
					hole.global_transform.origin = r.get_collision_point()
					hole.look_at(r.get_collision_point() + r.get_collision_normal(), Vector3.UP)
			anim_player.play("Shotgun Fire")

signal weapon_out_of_ammo

func fire_smg():
	var max_smg_ammo = 10
	var current_smg_ammo : int = max_smg_ammo
	if Input.is_action_pressed("Shoot"):
		if not anim_player.is_playing():
			guncam.translation = lerp(guncam.translation, Vector3(rand_range(MAX_CAM_SHAKE, -MAX_CAM_SHAKE), rand_range(MAX_CAM_SHAKE, -MAX_CAM_SHAKE), 0), 0.5)
			if raycast.is_colliding() and current_smg_ammo >= 0:
				var target = raycast.get_collider()
				if target.is_in_group("Enemy2"):
					target.health -= damage
				var hole = b_decal.instance()
				raycast.get_collider().add_child(hole)
				hole.global_transform.origin = raycast.get_collision_point()
				hole.look_at(raycast.get_collision_point() + raycast.get_collision_normal(), Vector3.UP)
				particle.emitting = true
				current_smg_ammo -= 1
				if current_smg_ammo == 0:
					emit_signal("weapon_out_of_ammo")
			elif current_smg_ammo < 0:
				print("Out of Ammo")
		anim_player.play("Smg Fire")

onready var particlelmg = $Pivot/Camera/Hand/LmgHand/Muzzleflashsmg2

func fire_lmg():
	if Input.is_action_pressed("Shoot"):
		if not anim_player.is_playing():
			camera.translation = lerp(camera.translation, Vector3(rand_range(MAX_CAM_SHAKE, -MAX_CAM_SHAKE), rand_range(MAX_CAM_SHAKE, -MAX_CAM_SHAKE), 0), 0.5)
			if raycast.is_colliding():
				var lmgb = lmgbullet.instance()
				machinegun.add_child(lmgb)
				lmgb.look_at(raycast.get_collision_point(), Vector3.UP)
				lmgb.shoot = true
				var target = raycast.get_collider()
				if target.is_in_group("Enemy2"):
					target.health -= lmgdamage
				var hole = b_decal.instance()
				raycast.get_collider().add_child(hole)
				hole.global_transform.origin = raycast.get_collision_point()
				hole.look_at(raycast.get_collision_point() + raycast.get_collision_normal(), Vector3.UP)
				particlelmg.emitting = true
		anim_player.play("Lmg Fire")
		
onready var particlesniper = $Pivot/Camera/Hand/SniperHand/muzzleflashshotgun2

func fire_sniper():
	if Input.is_action_just_pressed("Shoot"):
		if not anim_player.is_playing():
			camera.translation = lerp(camera.translation, Vector3(rand_range(MAX_CAM_SHAKE, -MAX_CAM_SHAKE), rand_range(MAX_CAM_SHAKE, -MAX_CAM_SHAKE), 0), 0.5)
			if raycast.is_colliding():
				var target = raycast.get_collider()
				if target.is_in_group("Enemy2"):
					target.health -= sniperdamage
				var hole = b_decal.instance()
				raycast.get_collider().add_child(hole)
				hole.global_transform.origin = raycast.get_collision_point()
				hole.look_at(raycast.get_collision_point() + raycast.get_collision_normal(), Vector3.UP)
				particlesniper.emitting = true
		anim_player.play("Sniper Fire")


func _input(event):
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				if current_weapon < 4:
					current_weapon += 1
				else:
					current_weapon = 1
			elif event.button_index == BUTTON_WHEEL_DOWN:
				if current_weapon > 1:
					current_weapon -= 1
				else:
					current_weapon = 4


func _physics_process(delta):
	
	running()
	weapon_select()
	
	velocity.y += gravity * delta
	var desired_velocity = get_input() * max_speed
	fire()
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)
	
	if jump and is_on_floor():
		velocity.y = jump_speed

func _process(delta):
	if health <= 0:
		queue_free()
	guncam.global_transform = camera.global_transform

