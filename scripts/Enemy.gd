extends CharacterBody2D

var health = 6
var is_dead = false

func do_damage():
	health -= 1
	print(health)
	if health <= 0 and not is_dead:
		is_dead = true
		$CollisionShape2D.disabled = true
		$AnimationPlayer.play("Tentacle_Die")
