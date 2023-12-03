extends Area2D

signal on_take_damage()

@export var health_component : HealthComponent
@export var entity_type : ENTITY
enum ENTITY {PLAYER, ENEMY, DESTRUCTABLE}

func _ready():
	match entity_type:
		0:
			set_collision_mask_value(6, true)
		1:
			set_collision_mask_value(5, true)
		2:
			set_collision_mask_value(5, true)
			set_collision_mask_value(6, true)
		

func _process(_delta):
	if Input.is_action_just_pressed('P'):
		take_damage(1)

func take_damage(amount):
	emit_signal("on_take_damage")
	health_component.reduce_health(amount)
	
func _on_area_entered(area):
	var damage_component = area.get_node("DamageComponent")
	if damage_component:
		print("Damage Value: ", damage_component)
	else:
		print("no damage component")
