extends Node

@export var basic_attack: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	owner.swung.connect(on_swung)


func on_swung():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var basic_attack_instance = basic_attack.instantiate() as Node2D
	player.get_parent().add_child(basic_attack_instance)
	
	basic_attack_instance.global_position = player.global_position
	basic_attack_instance.global_position.y -= player.get_node("CollisionShape2D").get_shape().size.y / 2
	if player.get_node("Sprite2D").flip_h == true:
		basic_attack_instance.global_position.x -= 45 
	else:
		basic_attack_instance.global_position.x += 45
