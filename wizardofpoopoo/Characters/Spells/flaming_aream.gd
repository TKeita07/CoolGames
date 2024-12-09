extends Area2D

var direction = Vector2(1,0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_areas()


func _on_timer_timeout() -> void:
	queue_free()

func set_direction(dir):
	direction = dir


func move_areas():
	var flame_speed = Vector2(1.3,0)
	
	translate(flame_speed.rotated(direction.angle()))
	


func _on_body_entered(body: Node2D) -> void:
	body.queue_free()
