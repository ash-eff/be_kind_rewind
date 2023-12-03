extends State

func enter(_msg:= {}) -> void:
	owner.set_animation('player_run')

func physics_update(_delta: float) -> void:
	var player_input_direction = owner.get_input_direction()
	#owner.velocity = lerp(owner.velocity, player_input_direction * owner.speed, _delta * owner.acceleration)
	owner.velocity.x = move_toward(owner.velocity.x, owner.speed * player_input_direction.x, owner.acceleration)
	owner.velocity.y = move_toward(owner.velocity.y, owner.speed * player_input_direction.y, owner.acceleration)
	owner.move_and_slide()
	owner.flip_sprite(owner.get_direction_to_mouse())
	if player_input_direction == Vector2.ZERO:
		owner.state_machine.transition_to("Idle")
