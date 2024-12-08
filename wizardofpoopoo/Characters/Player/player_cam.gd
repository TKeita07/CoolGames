extends Camera2D

# Variables pour gérer les différents modes
enum CameraMode { FOLLOW_PLAYER, LOCKED_POSITION }
var mode: CameraMode = CameraMode.FOLLOW_PLAYER

@onready var player = get_tree().get_nodes_in_group("Player")[0]  
# Position verrouillée
var locked_position: Vector2 = Vector2.ZERO


func _ready():
	pass

func _process(delta):
	match mode:
		CameraMode.FOLLOW_PLAYER:
			global_position = player.global_position
		CameraMode.LOCKED_POSITION:
			global_position = locked_position

# Fonction pour changer le mode de la caméra
func lock_to_position(position: Vector2):
	mode = CameraMode.LOCKED_POSITION
	locked_position = position

func follow_player():
	mode = CameraMode.FOLLOW_PLAYER
