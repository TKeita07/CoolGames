extends CharacterBody2D


const SPEED = 150.0
var rotation_speed = 1.5
var last_direction = "Down"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera_2d: Camera2D = %PlayerCam
@onready var dash_duration: Timer = %DashDuration
@onready var dash_coldown: Timer = %DashColdown
@onready var dash_animation: AnimationPlayer = %DashAnimation

var dashing : bool = false
var dash_vel = 1
var dash_direction = Vector2(0,0)
enum INPUT_SCHEME {KBM, GAMEPAD}
var current_input_scheme : INPUT_SCHEME = INPUT_SCHEME.KBM

func _ready() -> void:
	global_position.x = 32*10
	global_position.y = 32*10
	pass

func change_camera():
	print("aa")
	camera_2d.make_current()

func _physics_process(delta: float) -> void:

	var direction = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	var direction_gamepad = Input.get_vector("AIM_LEFT", "AIM_RIGHT", "AIM_UP", "AIM_DOWN")
	
	Input.warp_mouse(get_viewport().get_mouse_position()+ direction_gamepad* 2000.0*delta)
	
	var animation_name = "Move_"
	if velocity[0] == 0 and velocity[1] == 0:
		animation_name = "Idle_"
	
	if direction[1] < 0 :
		last_direction = "Up"
	elif direction[1] > 0 :
		last_direction = "Down"
	elif direction[0] < 0 :
		animated_sprite_2d.flip_h = true
		last_direction = "Side"
	elif direction[0] > 0 :
		animated_sprite_2d.flip_h = false
		last_direction = "Side" 
		
	animation_name += last_direction
	animated_sprite_2d.play(animation_name)
	
		
	if not dashing and Input.is_action_just_pressed("SHIFT"):
		dash_animation.stop()
		dash_animation.play("DashColdown")
		dashing = true
		dash_vel = 500
		dash_duration.start()
		dash_direction  = direction
	
	velocity = direction * SPEED + dash_direction * dash_vel

	move_and_slide()


func get_aim_direction(aim_position):
	var direction_gamepad = Input.get_vector("AIM_LEFT", "AIM_RIGHT", "AIM_UP", "AIM_DOWN")
	#if direction_gamepad:
		#return direction_gamepad
	
	return aim_position.direction_to(get_global_mouse_position())


func _on_dash_duration_timeout() -> void:
	dash_vel = 1 
	dash_coldown.start()
	
func _on_dash_coldown_timeout() -> void:
	dashing = false
