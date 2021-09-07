extends Spatial

const ADS_LERP = 20

export var camera_path : NodePath
var camera : Camera 

var current_weapon = 1

export var lmg_ads_position : Vector3
export var lmg_default_position : Vector3

export var shotgun_ads_position : Vector3
export var shotgun_default_position : Vector3

export var sniper_ads_position : Vector3
export var sniper_default_position : Vector3

export var smg_default_position : Vector3
export var smg_ads_position : Vector3
var fview = {"Default": 70, "ADS": 50}

func _ready():
	camera = get_node(camera_path)

func _process(delta):
	weapon_select()
	if current_weapon==1:
		if Input.is_action_pressed("Right_Click"):
			transform.origin = transform.origin.linear_interpolate(smg_ads_position, ADS_LERP * delta)
		else:
			transform.origin = transform.origin.linear_interpolate(smg_default_position, ADS_LERP * delta)
	
	
func weapon_select(): #weapon
	if Input.is_action_just_pressed("weapon1"):
		current_weapon = 1
	elif Input.is_action_just_pressed("weapon2"):
		current_weapon = 2
	elif Input.is_action_just_pressed("weapon3"):
		current_weapon = 3
	elif Input.is_action_just_pressed("weapon4"):
		current_weapon = 4
	
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

