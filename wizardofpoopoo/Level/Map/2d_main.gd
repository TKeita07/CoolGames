extends Node2D

@onready var shader_rect: ColorRect = %ShaderRect
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.activate_shader.connect(activate_shader)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func activate_shader(activate : bool):
	shader_rect.material.set_shader_parameter("activate", activate)
