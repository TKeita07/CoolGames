extends Resource
class_name DoorResource

@export var _side : Enums.Adjacent 
@export var _pose: Vector2i
var _used: bool = false


func _init(side : Enums.Adjacent = Enums.Adjacent.UP,  pose: Vector2i = Vector2i(0,0)):
	_side = side
	_pose = pose

func get_side():
	return _side

func get_pose():
	return _pose

func is_used():
	return _used
	
func set_used(used : bool):
	_used = used
