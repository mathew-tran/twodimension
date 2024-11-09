extends StaticBody2D

var IntendedPosition = Vector2.ZERO
var OwnerObject = null

var bIsKilled = false

var Progress = 0.0

func _process(delta):
	$Line2D.points[1] = to_local(OwnerObject.global_position)
	if bIsKilled:
		Progress += delta * 10
		$Line2D.points[0] = to_local(lerp(self.global_position, OwnerObject.global_position, Progress))
		$Sprite2D.visible = false
		if Progress >= 1:
			queue_free()
	else:
		$Line2D.points[0] = to_local(self.global_position)
		if $PinJoint2D.node_b != OwnerObject.get_path():
			if $KillTimer.time_left == 0.0:
				$KillTimer.start()
			
		
func _on_kill_timer_timeout():
	Kill()

func Kill():
	if bIsKilled:
		return
	bIsKilled = true
	
	
