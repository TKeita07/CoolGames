extends Object

class_name Aroom

var decallage = 32 * 20


var room_scene : Rooms
var type : Enums.RoomType
var map_pos : Vector2

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


func init(room_type : Enums.RoomType, pos : Vector2):
	map_pos = pos
	var room_path : String = Enums.RoomScenDict[room_type]
	var room = load(room_path)
	room_scene = room.instantiate()
	
	room_scene.global_position.x += (map_pos.x * decallage)
	room_scene.global_position.y +=  (map_pos.y * decallage)


func init_random(pos : Vector2):
	init(randi() % Enums.RoomType.size(), pos)

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
