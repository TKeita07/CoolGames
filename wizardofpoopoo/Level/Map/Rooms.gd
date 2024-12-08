extends Node2D

@onready var doors: Node2D =  %Doors
@onready var entree_doors_collision: CollisionShape2D = %DoorsCollision
@onready var entree_detection: CollisionShape2D = %InsideCollision
@onready var tile_map: TileMapLayer = %RoomTiles
@onready var room_cam: Camera2D = %RoomCam

@onready var player = get_tree().get_nodes_in_group("Player")[0]  
@onready var player_cam = get_tree().get_nodes_in_group("PlayerCam")[0] 
 
const ENTREE = preload("res://Level/Map/entree.tscn")
var player_in_room : bool = false
var room_cleared : bool = false

var doors_pos = {
	Enums.Adjacent.UP : Vector2(0,0),
	Enums.Adjacent.DOWN : Vector2(0,0),
	Enums.Adjacent.RIGHT : Vector2(0,0),
	Enums.Adjacent.LEFT : Vector2(0,0),
}

var map_pos : Vector2 = Vector2(0, 0)
var grid_size : Vector2 = Vector2(12, 12)
var tile_size : int = 32
var center_pos : Vector2 = Vector2(int(grid_size.x/2), int(grid_size.y/2)) * tile_size

func _process(delta: float) -> void:
	if player_in_room : 
		if Input.is_action_pressed("X"):
			room_end()
		if Input.is_action_pressed("Q"):
			change_camera()
		

		#var player_cam = player.get_node("%PlayerCam")
		#player_cam.global_position = player_cam.global_position.lerp(center_pos, delta * 0.4)
		
func initialisation():
	global_position.x = global_position.x + (4*32)
	global_position.y = global_position.y + (4*32)
	
	#room_cam.global_position = center_pos + Vector2(4*32,4*32)
	
func change_camera():
	player_cam.lock_to_position(global_position + center_pos)
	pass
	#if room_cam:
		#room_cam.make_current()


func add_door(adj : Enums.Adjacent):
	var new_door = ENTREE.instantiate()
	var pos = doors_pos[adj]
	var rotation = 0
	new_door.global_position.x = (pos.x * 32)
	new_door.global_position.y = (pos.y * 32)
	doors.add_child(new_door)
	new_door.set_parent(self)
	new_door.open_entree(true)
	
	var tile_pos
	match adj:
		Enums.Adjacent.UP: 
			rotation = 180
			new_door.global_position.x += 32
			new_door.global_position.y += 16
			tile_map.set_cell(pos, 2, Vector2(0, 6))
			tile_map.set_cell(Vector2(pos.x+1, pos.y), 2, Vector2(0, 6))
			
		Enums.Adjacent.DOWN: 
			rotation = 0
			new_door.global_position.x += 32
			new_door.global_position.y += 16
			tile_map.set_cell(pos, 2, Vector2(0, 6))
			tile_map.set_cell(Vector2(pos.x+1, pos.y), 2, Vector2(0, 6))
			
		Enums.Adjacent.RIGHT: 
			rotation = -90
			new_door.global_position.x += 16
			new_door.global_position.y += 32
			tile_map.set_cell(pos, 2, Vector2(0, 6))
			tile_map.set_cell(Vector2(pos.x, pos.y+1), 2, Vector2(0, 6))
			
		Enums.Adjacent.LEFT: 
			rotation = 90
			new_door.global_position.x += 16
			new_door.global_position.y += 32
			tile_map.set_cell(pos, 2, Vector2(0, 6))
			tile_map.set_cell(Vector2(pos.x, pos.y+1), 2, Vector2(0, 6))

	new_door.rotation_degrees = rotation
	
func room_exited():
	player_in_room = false
	player_cam.follow_player()
	

func start_room():
	player_in_room = true
	if not room_cleared:
		for door in doors.get_children():
			door.open_entree(false)
			door.disable_detection(true)
	change_camera()

func room_end():
	room_cleared = true
	for door in doors.get_children():
		door.open_entree(true)
		door.disable_detection(false)

func set_map_pose(mpos : Vector2):
	map_pos = mpos
