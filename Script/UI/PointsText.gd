extends Node2D


func Setup(amount):
	$PointsText.text = "+" + str(amount)


func _process(delta):
	global_position -= Vector2(0,400) * delta
	
func _on_timer_timeout():
	queue_free()
