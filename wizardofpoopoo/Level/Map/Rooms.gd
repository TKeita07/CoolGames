extends Node2D

@export var grid_size : Vector2i = Vector2i(16,16)
@export var doors_pos_array : Array[DoorResource]

 #[
	#DoorResource.new(Enums.Adjacent.UP),
	#DoorResource.new(Enums.Adjacent.DOWN), 
	#DoorResource.new(Enums.Adjacent.RIGHT),
	#DoorResource.new(Enums.Adjacent.LEFT)]

@onready var doors: Node2D =  %Doors
@onready var entree_doors_collision: CollisionShape2D = %DoorsCollision
@onready var entree_detection: CollisionShape2D = %InsideCollision
@onready var tile_map: TileMapLayer = %RoomTiles
@onready var room_cam: Camera2D = %RoomCam
@onready var enemies: Node2D = %Enemies
@onready var spawn_area: Polygon2D = %SpawnArea
@onready var player_cam

const ENEMY = preload("res://Characters/Enemy/enemy.tscn")
const ENTREE = preload("res://Level/Map/entree.tscn")
var player_in_room : bool = false
var room_cleared : bool = false
var enemy_nbr = 4

var map_pos : Vector2i = Vector2i(0, 0)
var tile_size : int = 32
var center_pos : Vector2i = Vector2i(int(grid_size.x/2), int(grid_size.y/2)) * tile_size

var tmp = "aa"

func _process(delta: float) -> void:
	if player_in_room : 
		if Input.is_action_just_released("X"):
			room_end()
		if Input.is_action_just_released("Q"):
			pass
		
		if enemies.get_child_count() <= 0:
			room_end()
		#var player_cam = player.get_node("%PlayerCam")
		#player_cam.global_position = player_cam.global_position.lerp(center_pos, delta * 0.4)
		
func initialisation():
	player_cam = get_tree().get_nodes_in_group("PlayerCam")[0] 
	#global_position.x = global_position.x
	#global_position.y = global_position.y 
	
	spawn_enemies()
	#room_cam.global_position = center_pos + Vector2(4*32,4*32)
	
func change_camera():
	player_cam.lock_to_position(global_position + Vector2(center_pos))
	pass
	#if room_cam:
		#room_cam.make_current()


func add_door(adj : Enums.Adjacent):
	var pos = get_door_pose_from_list(adj)
	if not pos:
		print("ERROR : no door available - " + tmp)
		return
	var new_door = ENTREE.instantiate()
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
			tile_map.set_cell(pos, 2, Vector2i(0, 6))
			tile_map.set_cell(Vector2i(pos.x+1, pos.y), 2, Vector2i(0, 6))
			
		Enums.Adjacent.DOWN: 
			rotation = 0
			new_door.global_position.x += 32
			new_door.global_position.y += 16
			tile_map.set_cell(pos, 2, Vector2i(0, 6))
			tile_map.set_cell(Vector2i(pos.x+1, pos.y), 2, Vector2i(0, 6))
			
		Enums.Adjacent.RIGHT: 
			rotation = -90
			new_door.global_position.x += 16
			new_door.global_position.y += 32
			tile_map.set_cell(pos, 2, Vector2i(0, 6))
			tile_map.set_cell(Vector2i(pos.x, pos.y+1), 2, Vector2i(0, 6))
			
		Enums.Adjacent.LEFT: 
			rotation = 90
			new_door.global_position.x += 16
			new_door.global_position.y += 32
			tile_map.set_cell(pos, 2, Vector2i(0, 6))
			tile_map.set_cell(Vector2i(pos.x, pos.y+1), 2, Vector2i(0, 6))

	new_door.rotation_degrees = rotation
	
func room_exited():
	player_in_room = false
	player_cam.follow_player()
	
	Signals.activate_shader.emit(true)

	

func start_room():
	player_in_room = true
	if not room_cleared:
		for door in doors.get_children():
			door.open_entree(false)
			door.disable_detection(true)
	change_camera()
	
	Signals.activate_shader.emit(false)

func room_end():
	room_cleared = true
	for door in doors.get_children():
		door.open_entree(true)
		door.disable_detection(false)

func set_map_pose(mpos : Vector2i):
	map_pos = mpos

func get_door_pose_from_list(adj : Enums.Adjacent):
	var door_pose = null
	for door_res in doors_pos_array:
		if door_res.get_side() == adj:
			door_pose = door_res.get_pose()

	return door_pose

func spawn_enemies():
	var n = 0
	while n < enemy_nbr:
		var lenght_X = grid_size.x * tile_size
		var lenght_Y = grid_size.y * tile_size
		var x = randi_range(center_pos.x - int(lenght_X/2), center_pos.x + int(lenght_X/2))
		var y = randi_range(center_pos.y - int(lenght_Y/2), center_pos.y + int(lenght_Y/2))
		var rand_point = Vector2(x,y)

		if Geometry2D.is_point_in_polygon(rand_point, spawn_area.polygon):
			var enemy = ENEMY.instantiate()
			
			enemies.add_child(enemy)
			enemy.global_position = global_position+ rand_point
			n += 1
