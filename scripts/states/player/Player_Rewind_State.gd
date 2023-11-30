extends State

func enter(_msg:= {}) -> void:
	owner.hide_weapon(true)
	owner.emit_signal("on_player_rewind")
	owner.set_animation('player_static')

func update(_delta: float) -> void:
	owner.velocity = lerp(owner.velocity, Vector2.ZERO * owner.speed, _delta * owner.acceleration)
	owner.move_and_slide()
