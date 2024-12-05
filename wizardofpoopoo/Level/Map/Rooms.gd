extends Node2D

@onready var sortie: Node2D = $Doors/Sortie
@onready var entree: Node2D = $Doors/Entree
@onready var entree_collision: CollisionShape2D = $Doors/Entree/StaticBody2D/CollisionShape2D
@onready var sortie_collision: CollisionShape2D = $Doors/Sortie/StaticBody2D/CollisionShape2D




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("X"):
		room_end()


func room_end():
	open_entree(true)
	open_sortie(true)

func open_entree(open: bool):
	entree.visible = not open
	entree_collision.set_deferred("disabled", open)

func open_sortie(open: bool):
	sortie.visible = not open
	sortie_collision.set_deferred("disabled", open)
