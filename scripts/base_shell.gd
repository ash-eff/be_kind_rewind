extends Node2D


func set_direction(dir):
	if dir.x > 0:
		$AnimatedSprite2D.position.x = -40.0
		$AnimatedSprite2D.scale.x = 1.0
	else:
		$AnimatedSprite2D.position.x = 40.0
		$AnimatedSprite2D.scale.x = -1.0


func _on_timer_timeout():
	queue_free()


func _on_vcr_rewind_start():
	$Timer.set_paused(true)


func _on_vcr_rewind_complete():
	$Timer.set_paused(false)
