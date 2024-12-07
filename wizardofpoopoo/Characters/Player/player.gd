extends CharacterBody2D


const SPEED = 300.0
var rotation_speed = 1.5
var last_direction = "Down"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	global_position.x = 32*10
	global_position.y = 32*10
	pass
	
func _physics_process(delta: float) -> void:
	
	var direction = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	velocity = direction * SPEED
	
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
	move_and_slide()
