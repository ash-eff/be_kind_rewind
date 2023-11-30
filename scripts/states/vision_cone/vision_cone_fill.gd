extends State

func update(_delta: float) -> void:
	owner.mesh_instance.shader_fill_value -= owner.shader_fill_amount
	if owner.mesh_instance.shader_fill_value <= 0.0:
		state_machine.transition_to("Alert")
