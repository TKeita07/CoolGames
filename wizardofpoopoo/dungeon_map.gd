extends Node2D

@onready var map_list: Node2D = $MapList

var room_array = []
var nbr_rooms = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_first_room()
	generate_dungeon()


func generate_first_room():
	var first_room = Aroom.new()
	first_room.init_random(Vector2(0,0))
	map_list.add_child(first_room.room_scene)
	room_array.append(first_room)


func _process(delta: float) -> void:
	if Input.is_action_just_released("H"):
		generate_dungeon()
		pass
	if Input.is_action_just_released("Q"):
		pass

func generate_dungeon():
	var n = 0
	while n < nbr_rooms : 
		var random_room = room_array.pick_random()

		var radom_adj = randi() % 4
		var nex_pos = Vector2(0,0)
		var solution_found = false
		for i in range(4):
			var adj = (radom_adj + i) % 4 
			nex_pos = get_pos_from_adj(random_room.get_pos(), adj)
			if not pos_occupied(nex_pos):
				add_room(nex_pos, adj)
				random_room.adjacent_rooms[adj] = true
				solution_found = true
				break
		if solution_found:
			n += 1

func pos_occupied(pos):
	for r in room_array:
		if r.get_pos() == pos:
			return true
	return false

func get_pos_from_adj(pos, adj):
	var next_pos = pos
	match adj:
		Enums.Adjacent.UP: 
			next_pos.y += 1
		Enums.Adjacent.DOWN: 
			next_pos.y -= 1
		Enums.Adjacent.RIGHT: 
			next_pos.x += 1
		Enums.Adjacent.LEFT: 
			next_pos.x -= 1
	return next_pos


func add_room(pos, adj):

	var room = Aroom.new()
	room.init_random(pos)
	room.set_adjacent_room(adj)
	
	map_list.add_child(room.room_scene)
	room_array.append(room)
	
