extends State

func enter(_msg:= {}) -> void:
	owner.set_animation('player_idle')
	owner.emit_signal('on_crouch')
	
func handle_input(_event: InputEvent) -> void:
	if _event is InputEventKey and _event.pressed == false:
		if _event.keycode == KEY_SHIFT:
			owner.state_machine.transition_to("Idle")

func update(_delta: float) -> void:
	var player_input_direction = owner.get_input_direction()
	owner.velocity = lerp(owner.velocity, player_input_direction * (owner.speed / 4.0), _delta * owner.acceleration)
	owner.move_and_slide()
	owner.flip_sprite(owner.get_direction_to_mouse())
	if player_input_direction != Vector2.ZERO:
		owner.set_animation('player_sneak')
	else:
		owner.set_animation('player_crouch')

func exit() -> void:
	owner.emit_signal('on_stand')
