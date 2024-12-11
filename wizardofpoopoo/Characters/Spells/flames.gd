extends Node2D

@onready var flames_gpu: GPUParticles2D = %FlamesGPU
var player
const FLAMING_AREAM = preload("res://Characters/Spells/flaming_aream.tscn")
@onready var areas: Node2D = $Areas

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flames_gpu.emitting = false
	player = get_tree().get_nodes_in_group("Player")
	if player:
		player = player[0] 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_pressed("LeftClick"):
		flames_gpu.emitting = true
		spawn_flames()
	else:
		flames_gpu.emitting = false

	
func spawn_flames():
	var direction = flames_gpu.global_position.direction_to(get_global_mouse_position())
	if player:
		direction = player.get_aim_direction(flames_gpu.global_position)
	
	var flaming_area = FLAMING_AREAM.instantiate()
	areas.add_child(flaming_area)
	
	if player:
		var decallage = Vector2(20, 0)
		decallage = decallage.rotated(direction.angle())
		flames_gpu.global_position = player.global_position + decallage
		flaming_area.global_position = flames_gpu.global_position
	
	
	flaming_area.rotation = direction.angle()
	flames_gpu.rotation = direction.angle()
	#flames_gpu.look_at(mouse_position)
	
	flaming_area.set_direction(direction)
