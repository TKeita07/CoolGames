extends Node2D

@onready var map_list: Node2D = $MapList
@onready var tile_map: TileMapLayer = $TileMapLayer
@onready var tile_map_2: TileMapLayer = $TileMapLayer2

var decallage = 32 * 40
var room_array = []
var room_mat = []
var nbr_rooms = 25
var ground_atlas = Vector2i(0, 12)
var wall_atlas = Vector2i(2, 3)
var temp_atlas = Vector2i(0, 7)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	room_mat.append([])
	generate_first_room()

	#generate_dungeon()
	room_array[0].room_scene.start_room()
	
	generate_dungeonV2()


func generate_first_room():
	var first_room = Aroom.new()
	first_room.new_init(0)
	map_list.add_child(first_room.room_scene)
	var new_center_pos = Vector2i(2, 2) + Vector2i(int(first_room.get_size().x/2), int(first_room.get_size().y/2))
	first_room.set_center_pos(new_center_pos)
	first_room.room_scene.initialisation()
	room_array.append(first_room)
	updateBackendMap(first_room.get_center_pos(), first_room.get_size())

func updateBackendMap(centerPos : Vector2i, room_size : Vector2i):
	
	for i in range(centerPos.x - int(room_size.x/2), centerPos.x + int(room_size.x/2)):
		for j in range(centerPos.y - int(room_size.y/2), centerPos.y + int(room_size.y/2)):

			tile_map_2.set_cell(Vector2i(i, j), 2, temp_atlas)
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_released("H"):
		generate_dungeon()
		pass

func get_random_side_8():
	var random = (randi() % 8)
	match random:
		0:  return Vector2i(0,1)
		1:  return Vector2i(0,-1)
		2:  return Vector2i(1,0)
		3:  return Vector2i(-1,0)
		4:  return Vector2i(1,1)
		5:  return Vector2i(1,-1)
		6:  return Vector2i(-1,1)
		7:  return Vector2i(-1,-1)
	

func get_random_side_4():
	var random = (randi() % 4)
	match random:
		0:  return Vector2i(0,1)
		1:  return Vector2i(0,-1)
		2:  return Vector2i(1,0)
		3:  return Vector2i(-1,0)

func generate_dungeonV2():
	var n = 0
	while n < 25 : 
		var random_room = room_array.pick_random()
		var random_side = get_random_side_4()
		var random_x = random_side.x
		var random_y = random_side.y
		var tile_pos = random_room.get_center_pos() 
		tile_pos += Vector2i(int(random_room.get_size().x/2) * random_x, int(random_room.get_size().y/2) * random_y)
		tile_pos += Vector2i(random_x, random_y) *4
		while tile_map_2.get_cell_tile_data(tile_pos) != null:
			tile_pos += Vector2i(random_x, random_y)
		
		#tile_pos -=Vector2i(random_x, random_y) *4
		var solution_found = false
		var room_type = -1
		var new_room
		for i in range(Enums.RoomType.size()):
			new_room = Aroom.new()
			if room_type == -1 :
				new_room.new_init_random()
				room_type = new_room.get_room_type()
			else:
				new_room.new_init((room_type + i) % Enums.RoomType.size())
			
			var new_center_pos = tile_pos +  Vector2i(int(new_room.get_size().x/2) * random_x, int(new_room.get_size().y/2) * random_y)
			new_center_pos += Vector2i(random_x, random_y) *2
			#new_center_pos += Vector2i(4*random_x, 4*random_y)
			new_room.set_center_pos(new_center_pos)
			if does_room_fit(new_room):
				#updateBackendMap(new_center_pos, new_room.get_size())
				#new_room.add_entrance(adj)
				map_list.add_child(new_room.room_scene)
				new_room.room_scene.initialisation()
				room_array.append(new_room)
				solution_found = true
				print(new_room.room_scene.tmp)
				break
		if solution_found:
			n += 1

func does_room_fit(new_room):
	for room in room_array:
		if new_room._recte.intersects(room._recte):
			return false
	return true


func generate_dungeon():
	var n = 0
	while n < nbr_rooms : 
		var random_room = room_array.pick_random()

		var radom_adj = randi() % 4
		var nex_pos = Vector2i(0,0)
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
	var r_door_pos = room.room_scene.get_door_pose_from_list(adj)
	var nr_door_pos = new_room.room_scene.get_door_pose_from_list(get_adj_inv(adj))
	if not r_door_pos or not nr_door_pos:
		print("ERROR : no door available for HALLWAY")
		return
	var r_pos = room.get_pos()
	var nr_pos = new_room.get_pos()
	# Decallage salles
	var p_d = (r_pos * Vector2i(20,20)) + r_door_pos
	var p_f = (nr_pos * Vector2i(20,20)) + nr_door_pos

	# Ajout espace de couloirs
	p_d += Vector2i(4,4)
	p_f += Vector2i(4,4)

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
			tile_map.set_cell(Vector2i(i, j), 2, wall_atlas)
		
	var pos_d = Vector2i(pos_debut.x, pos_debut.y+1)
	var pos_f = Vector2i(pos_fin.x, pos_fin.y-1)
	
	for i in range(int(dist_y/2 + 1)):
		tile_map.set_cell(Vector2i(pos_d.x, pos_d.y+i), 2, ground_atlas)
		tile_map.set_cell(Vector2i(pos_d.x+1, pos_d.y+i), 2, ground_atlas)
		
		tile_map.set_cell(Vector2i(pos_f.x, pos_f.y-i), 2, ground_atlas)
		tile_map.set_cell(Vector2i(pos_f.x+1, pos_f.y-i), 2, ground_atlas)
	
	pos_d = Vector2i(x_min+2, pos_debut.y+int(dist_y/2))
	for i in range(int(dist_x)):
		tile_map.set_cell(Vector2i(pos_d.x+i, pos_d.y), 2, ground_atlas)
		tile_map.set_cell(Vector2i(pos_d.x+i, pos_d.y+1), 2,ground_atlas)


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
	room.room_scene.initialisation()
	room.add_entrance(adj)
	
	room_array.append(room)
	return room
