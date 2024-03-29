extends Node
class_name HealthComponent
signal died
signal health_changed

@export var max_health: float = 10.0
var current_health: float

func _ready():
	current_health = max_health


func damage(damageVal: float):
	current_health = max(current_health - damageVal, 0.0)
	health_changed.emit()
	if current_health == 0:
		died.emit(owner.exp_given)
		owner.queue_free()
