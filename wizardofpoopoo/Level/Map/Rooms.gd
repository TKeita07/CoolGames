extends Node2D

@onready var sortie: Node2D = $Doors/Sortie
@onready var entree: Node2D = $Doors/Entree
@onready var entree_doors_collision: CollisionShape2D = $Doors/Entree/StaticBody2D/CollisionShape2D
@onready var sortie_doors_collision: CollisionShape2D = $Doors/Sortie/StaticBody2D/CollisionShape2D
@onready var entree_detection: CollisionShape2D = $Doors/Entree/Area2D/CollisionShape2D
@onready var entree_pose: Marker2D = $Doors/EntreePose
@onready var sortie_pose: Marker2D = $Doors/SortiePose

var player_in_room : bool


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("X") and player_in_room:
		room_end()

func initialisation():
	global_position.x = global_position.x + (4*32)
	global_position.y = global_position.y + (4*32)
	entree.global_position = entree_pose.global_position
	sortie.global_position = sortie_pose.global_position

func room_end():
	player_in_room = false
	open_entree(true)
	open_sortie(true)

func start_room():
	player_in_room = true
	open_entree(false)
	entree_detection.set_deferred("disabled", true)

func open_entree(open: bool):
	if entree and entree_doors_collision :
		entree.visible = not open
		entree_doors_collision.set_deferred("disabled", open)

func open_sortie(open: bool):
	if sortie and sortie_doors_collision:
		sortie.visible = not open
		sortie_doors_collision.set_deferred("disabled", open)
