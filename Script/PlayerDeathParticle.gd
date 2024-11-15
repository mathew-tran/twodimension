extends CPUParticles2D


func Setup(playerVelocity : Vector2):
	direction = playerVelocity.rotated(270)
	
func _ready():
	emitting = true


func _on_timer_timeout():
	queue_free()
