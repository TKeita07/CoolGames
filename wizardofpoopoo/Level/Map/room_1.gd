extends Rooms

func _ready() -> void:
	doors_pos[Enums.Adjacent.UP] = Vector2(3,0)
	doors_pos[Enums.Adjacent.DOWN] =Vector2(8,11)
	doors_pos[Enums.Adjacent.RIGHT] = Vector2(11,5)
	doors_pos[Enums.Adjacent.LEFT] = Vector2(0,5)

	initialisation()
