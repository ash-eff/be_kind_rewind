extends 'res://scripts/states/weapons/base_weapon.gd'

func shoot():
	if cooldown.is_stopped():
		cooldown.start()
		var dir_to_mouse = (get_global_mouse_position() - owner.global_position).normalized()
		var angle = rad_to_deg(atan2(dir_to_mouse.y, dir_to_mouse.x))
		var angle_offset = spread_angle / (number_of_bullets - 1.0)
		var starting_angle = angle - spread_angle / 2.0
		
		eject_shell()
		
		for i in range(number_of_bullets):
			var offset = randi_range(-4, 4)
			starting_angle += offset
			var new_angle = starting_angle + i * angle_offset
			var look_direction = Vector2(cos(deg_to_rad(new_angle)), sin(deg_to_rad(new_angle))).normalized()
			var bullet = Bullet.instantiate()

			bullet.look_at(look_direction)
			world.add_child(bullet)
			bullet.global_position = global_position
