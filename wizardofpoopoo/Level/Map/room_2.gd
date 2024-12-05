extends Rooms
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	open_entree(true)
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	open_entree(false)
