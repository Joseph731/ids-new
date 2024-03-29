extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent


func _ready():
	area_entered.connect(on_area_entered)
	


func on_area_entered(other_area: Area2D):
	if !(other_area is HitboxComponent):
		return
	if health_component == null:
		return
	
	var hitbox_component = other_area as HitboxComponent
	
	if hitbox_component.enemies_hit < hitbox_component.max_enemies_hit:
		hitbox_component.enemies_hit += 1
		if !health_component.died.is_connected(hitbox_component.get_node("../../ExperienceManager").on_died):
			health_component.died.connect(hitbox_component.get_node("../../ExperienceManager").on_died)
		health_component.damage(hitbox_component.damage)
		get_parent().hurt(hitbox_component.get_node("../..").global_position.x)
