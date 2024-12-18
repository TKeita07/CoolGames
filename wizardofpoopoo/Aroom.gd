extends Object

class_name Aroom

var decallage = 32


var room_scene
var type : Enums.RoomType
var map_pos : Vector2i
var _center_pos : Vector2i
var _recte : Rect2

var adjacent_rooms = {
	Enums.Adjacent.UP : false,
	Enums.Adjacent.DOWN: false,
	Enums.Adjacent.RIGHT: false,
	Enums.Adjacent.LEFT: false
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func init(room_type : Enums.RoomType, pos : Vector2i):
	map_pos = pos
	var room_path : String = Enums.RoomScenDict[room_type]
	var room = load(room_path)
	room_scene = room.instantiate()
	room_scene.tmp = str(room_type)
	room_scene.global_position.x += (map_pos.x * decallage)
	room_scene.global_position.y +=  (map_pos.y * decallage)
	
	_center_pos = pos + Vector2i(4,4) + Vector2i(int(get_size().x/2), int(get_size().y/2))


func init_random(pos : Vector2i):
	init(randi() % Enums.RoomType.size(), pos)

func new_init(room_type : Enums.RoomType):
	var room_path : String = Enums.RoomScenDict[room_type]
	var room = load(room_path)
	room_scene = room.instantiate()
	room_scene.tmp = str(room_type)
	
func new_init_random():
	new_init(randi() % Enums.RoomType.size())




func adjecent_full():
	for adj in adjacent_rooms:
		if not adjacent_rooms[adj]:
			return false
	return true

func add_exit(adjacent : Enums.Adjacent):
	room_scene.add_door(adjacent)
	adjacent_rooms[adjacent] = true

func add_entrance(adjacent : Enums.Adjacent):
	var adj : Enums.Adjacent
	match adjacent :
		Enums.Adjacent.UP: 
			adj = Enums.Adjacent.DOWN
		Enums.Adjacent.DOWN: 
			adj = Enums.Adjacent.UP
		Enums.Adjacent.RIGHT: 
			adj = Enums.Adjacent.LEFT
		Enums.Adjacent.LEFT: 
			adj = Enums.Adjacent.RIGHT
	
	room_scene.add_door(adj)
	adjacent_rooms[adj] = true

func adjencent_exist(adjacent : Enums.Adjacent):
	return adjacent_rooms[adjacent]
	
func get_pos():
	return map_pos


func get_room_type():
	return type

func get_size():
	return room_scene.grid_size

func set_center_pos(center_pos : Vector2i):
	room_scene.global_position.x +=   center_pos.x*32 + 2*32 - 10*32
	room_scene.global_position.y +=   center_pos.y*32 + 2*32  - 10*32
	
	_recte = Rect2((center_pos - Vector2i(10,10))*32, (get_size()+Vector2i(4,4))*32)
	print(_recte)
	_center_pos = center_pos



func get_center_pos():
	return _center_pos
