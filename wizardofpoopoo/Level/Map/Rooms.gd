extends Node2D

@onready var doors: Node2D = $Doors
@onready var entree_doors_collision: CollisionShape2D = $Doors/Entree/StaticBody2D/CollisionShape2D
@onready var sortie_doors_collision: CollisionShape2D = $Doors/Sortie/StaticBody2D/CollisionShape2D
@onready var entree_detection: CollisionShape2D = $Doors/Entree/Area2D/CollisionShape2D
@onready var tile_map: TileMapLayer = $TileMaps/RoomLayer

const ENTREE = preload("res://Level/Map/entree.tscn")
var player_in_room : bool

var doors_pos = {
	Enums.Adjacent.UP : Vector2(0,0),
	Enums.Adjacent.DOWN : Vector2(0,0),
	Enums.Adjacent.RIGHT : Vector2(0,0),
	Enums.Adjacent.LEFT : Vector2(0,0),
}
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("X") and player_in_room:
		room_end()

func initialisation():
	global_position.x = global_position.x + (4*32)
	global_position.y = global_position.y + (4*32)



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
	

func start_room():
	player_in_room = true
	for door in doors.get_children():
		door.open_entree(false)
		door.disable_detection()

func room_end():
	player_in_room = false
	for door in doors.get_children():
		door.open_entree(true)
		door.disable_detection()
