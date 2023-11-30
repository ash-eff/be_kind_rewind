extends State

func enter(_msg:= {}) -> void:
	owner.mesh_instance.shader_fill_value = 0.0
	owner.on_player_spotted()
