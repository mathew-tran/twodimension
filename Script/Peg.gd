extends StaticBody2D

var bIsPressed = false
var bIsKilled = false

var Progress = 0.0

func _process(delta):
	if bIsKilled:
		Progress += delta * 5
		var scaleAmount = lerp(1, 0, Progress) 
		scale = Vector2.ONE * scaleAmount
		if Progress >= 1:
			queue_free()
	
func _on_area_2d_body_entered(body):
	if bIsPressed:
		return
		
	bIsPressed = true
	$Sprite2D.texture = load("res://Art/Peg/Peg_Blue_Highlight.png")
	$Timer.start()
	$CPUParticles2D.emitting = true


func _on_timer_timeout():
	bIsKilled = true
