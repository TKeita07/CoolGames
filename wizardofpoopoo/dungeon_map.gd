extends Node2D

@onready var map_list: Node2D = $MapList
@onready var tile_map: TileMapLayer = $TileMapLayer

var room_array = []
var nbr_rooms = 25
var ground_atlas = Vector2(0, 12)
var wall_atlas = Vector2(2, 3)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_first_room()

	generate_dungeon()
	room_array[0].room_scene.start_room()


func generate_first_room():
	var first_room = Aroom.new()
	first_room.init(0, Vector2(0,0))
	map_list.add_child(first_room.room_scene)
	room_array.append(first_room)


func _process(delta: float) -> void:
	if Input.is_action_just_released("H"):
		generate_dungeon()
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
				var new_room = add_room(nex_pos, adj)
				add_hallway(random_room, new_room, adj)
				random_room.add_exit(adj)
				solution_found = true
				break
		if solution_found:
			n += 1

func get_adj_inv(adjacent):
	var adj = 0
	match adjacent :
		Enums.Adjacent.UP: 
			adj = Enums.Adjacent.DOWN
		Enums.Adjacent.DOWN: 
			adj = Enums.Adjacent.UP
		Enums.Adjacent.RIGHT: 
			adj = Enums.Adjacent.LEFT
		Enums.Adjacent.LEFT: 
			adj = Enums.Adjacent.RIGHT
	return adj

func add_hallway(room, new_room, adj):
	var r_door_pos = room.room_scene.doors_pos[adj]
	var nr_door_pos = new_room.room_scene.doors_pos[get_adj_inv(adj)]
	
	var r_pos = room.get_pos()
	var nr_pos = new_room.get_pos()
	# Decallage salles
	var p_d = (r_pos * Vector2(20,20)) + r_door_pos
	var p_f = (nr_pos * Vector2(20,20)) + nr_door_pos

	# Ajout espace de couloirs
	p_d += Vector2(4,4)
	p_f += Vector2(4,4)

	if adj == Enums.Adjacent.UP or adj == Enums.Adjacent.DOWN:
		generate_hallway_verticale(p_d, p_f)
	else : 
		generate_hallway_horizontale(p_d, p_f)

func generate_hallway_verticale(pos_room1, pos_room2):
	var dist_x = abs(pos_room1.x - pos_room2.x)
	var dist_y = abs(pos_room1.y - pos_room2.y)
	
	var pos_debut = pos_room1
	var pos_fin = pos_room2
	if pos_room1.y > pos_room2.y:
		pos_debut = pos_room2
		pos_fin = pos_room1
		
		
	var x_min = min(pos_debut.x, pos_fin.x)
	var y_min = min(pos_debut.y, pos_fin.y)
	for i in range(x_min-1, x_min + dist_x + 3):
		for j in range(y_min+1, y_min + dist_y):
			tile_map.set_cell(Vector2(i, j), 2, wall_atlas)
		
	var pos_d = Vector2(pos_debut.x, pos_debut.y+1)
	var pos_f = Vector2(pos_fin.x, pos_fin.y-1)
	
	for i in range(int(dist_y/2 + 1)):
		tile_map.set_cell(Vector2(pos_d.x, pos_d.y+i), 2, ground_atlas)
		tile_map.set_cell(Vector2(pos_d.x+1, pos_d.y+i), 2, ground_atlas)
		
		tile_map.set_cell(Vector2(pos_f.x, pos_f.y-i), 2, ground_atlas)
		tile_map.set_cell(Vector2(pos_f.x+1, pos_f.y-i), 2, ground_atlas)
	
	pos_d = Vector2(x_min+2, pos_debut.y+int(dist_y/2))
	for i in range(int(dist_x)):
		tile_map.set_cell(Vector2(pos_d.x+i, pos_d.y), 2, ground_atlas)
		tile_map.set_cell(Vector2(pos_d.x+i, pos_d.y+1), 2,ground_atlas)


func generate_hallway_horizontale(pos_room1, pos_room2):
	var dist_x = abs(pos_room1.x - pos_room2.x)
	var dist_y = abs(pos_room1.y - pos_room2.y)
	
	var pos_debut = pos_room1
	var pos_fin = pos_room2
	if pos_room1.x > pos_room2.x:
		pos_debut = pos_room2
		pos_fin = pos_room1
		
		
	var x_min = min(pos_debut.x, pos_fin.x)
	var y_min = min(pos_debut.y, pos_fin.y)
	for i in range(x_min+1, x_min + dist_x ):
		for j in range(y_min - 1, y_min + dist_y + 3):
			tile_map.set_cell(Vector2(i, j), 2, wall_atlas)
			
	var pos_d = Vector2(pos_debut.x+1, pos_debut.y)
	var pos_f = Vector2(pos_fin.x-1, pos_fin.y)
	
	for i in range(int(dist_x/2 + 1)):
		tile_map.set_cell(Vector2(pos_d.x+i, pos_d.y), 2, ground_atlas)
		tile_map.set_cell(Vector2(pos_d.x+i, pos_d.y+1), 2, ground_atlas)
		
		tile_map.set_cell(Vector2(pos_f.x-i, pos_f.y), 2, ground_atlas)
		tile_map.set_cell(Vector2(pos_f.x-i, pos_f.y+1), 2, ground_atlas)
	
	pos_d = Vector2(pos_debut.x+int(dist_x/2), y_min+2)
	for i in range(int(dist_y)):
		tile_map.set_cell(Vector2(pos_d.x, pos_d.y+i), 2, ground_atlas)
		tile_map.set_cell(Vector2(pos_d.x+1, pos_d.y+i), 2, ground_atlas)
	

func pos_occupied(pos):
	for r in room_array:
		if r.get_pos() == pos:
			return true
	return false

func get_pos_from_adj(pos, adj):
	var next_pos = pos
	match adj:
		Enums.Adjacent.UP: 
			next_pos.y -= 1
		Enums.Adjacent.DOWN: 
			next_pos.y += 1
		Enums.Adjacent.RIGHT: 
			next_pos.x += 1
		Enums.Adjacent.LEFT: 
			next_pos.x -= 1
	return next_pos


func add_room(pos, adj):

	var room = Aroom.new()
	room.init_random(pos)
	map_list.add_child(room.room_scene)
	room.add_entrance(adj)
	
	room_array.append(room)
	return room
