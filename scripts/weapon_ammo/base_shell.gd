extends Node2D


func set_direction(dir):
	if dir.x > 0:
		$AnimatedSprite2D.offset.x = -48
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.offset.x = 48
		$AnimatedSprite2D.flip_h = true


func _on_timer_timeout():
	queue_free()


func _on_vcr_rewind_start():
	$Timer.set_paused(true)


func _on_vcr_rewind_complete():
	$Timer.set_paused(false)
