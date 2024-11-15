extends RigidBody2D

func _process(delta):
	global_position += Vector2.UP * 100 * delta
