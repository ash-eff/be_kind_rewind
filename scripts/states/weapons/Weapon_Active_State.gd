extends State

func update(_delta):
	var dir = owner.get_direction()
	owner.flip_sprite(dir)
	owner.rotate_weapon(dir)
