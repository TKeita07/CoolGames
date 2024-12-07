extends Rooms

func _ready() -> void:
	doors_pos[Enums.Adjacent.UP] = Vector2(5,0)
	doors_pos[Enums.Adjacent.DOWN] =Vector2(2,11)
	doors_pos[Enums.Adjacent.RIGHT] = Vector2(11,2)
	doors_pos[Enums.Adjacent.LEFT] = Vector2(0,5)

	initialisation()
