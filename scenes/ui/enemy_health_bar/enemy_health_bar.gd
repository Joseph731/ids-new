extends TextureProgressBar

@export var health_component: HealthComponent


func _ready():
	health_component.health_changed.connect(on_health_changed)
	update()

func update():
	value = health_component.current_health * 100 / health_component.max_health


func on_health_changed():
	update()
