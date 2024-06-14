extends Area2D
class_name PlayerHurtboxComponent

@export var health_component: PlayerHealthComponent

@onready var invincible_timer = $Invincible

func _ready():
	area_entered.connect(on_area_entered)
	invincible_timer.timeout.connect(on_invincible_timer_timeout)
	


func on_area_entered(other_area: Area2D):
	if !(other_area is HurtboxComponent):
		return
	if health_component == null:
		return
	
	
	if invincible_timer.is_stopped():
		health_component.damage(1)
		get_parent().hurt(other_area.owner.global_position.x)
		set_deferred("monitoring", false)
		invincible_timer.start()
	


func on_invincible_timer_timeout():
	monitoring = true
