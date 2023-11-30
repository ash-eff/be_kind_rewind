extends State

func enter(_msg:= {}) -> void:
	owner.sprite_rotator.visible = false
	
func exit() -> void:
	owner.sprite_rotator.visible = true
