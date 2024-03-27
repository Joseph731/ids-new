extends Node

@export var slime_scene: PackedScene

func _ready():
	$Timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
	if get_node("../Slimes").get_child_count() < 6:
		var slime = slime_scene.instantiate() as Node2D
		get_node("../Slimes").add_child(slime)
		slime.global_position = Vector2(randi_range(0, 500), 0)
