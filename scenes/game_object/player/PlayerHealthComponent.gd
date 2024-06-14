extends Node
class_name PlayerHealthComponent
signal player_died
signal health_changed

@export var max_health: float = 1000.0
var current_health: float

func _ready():
	current_health = max_health
	player_died.connect(owner.on_died)


func damage(damageVal: float):
	current_health = max(current_health - damageVal, 0.0)
	health_changed.emit()
	if current_health == 0:
		player_died.emit()
