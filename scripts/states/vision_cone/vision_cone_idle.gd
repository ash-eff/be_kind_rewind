extends State

func update(_delta: float) -> void:
	if owner.mesh_instance.shader_fill_value < 0.5:
		owner.mesh_instance.shader_fill_value += owner.shader_reduce_amount
