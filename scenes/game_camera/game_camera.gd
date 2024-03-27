extends Camera2D

var target_postion = Vector2.ZERO
var enemies_hit: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	acquire_target()
	global_position = global_position.lerp(target_postion, 1.0 - exp(-delta * 20))

func acquire_target():
	var player = get_tree().get_first_node_in_group("player") as CharacterBody2D
	if player == null:
		return
	
	target_postion = player.global_position
