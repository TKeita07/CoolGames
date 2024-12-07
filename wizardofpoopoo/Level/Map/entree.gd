extends Node2D

@onready var collision_shape: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var detection_shape: CollisionPolygon2D = $Area2D/CollisionPolygon2D

var parent : Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_parent(p):
	parent = p

func open_entree(open: bool):
	visible = not open
	collision_shape.set_deferred("disabled", open)

func disable_detection():
	detection_shape.set_deferred("disabled", true)

func _on_area_2d_body_entered(body: Node2D) -> void:
	parent.start_room()
	
