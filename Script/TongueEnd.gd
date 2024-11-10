extends StaticBody2D

var IntendedPosition = Vector2.ZERO
var OwnerObject = null

var bIsKilled = false

var Progress = 0.0

var PullSpeed = 25

var bInitialImpulse = false

var MaxLength = 500

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
				$Line2D.width *= .5
		else:
			$Line2D.default_color = Color.RED
			$Sprite2D.modulate = Color.RED
func _physics_process(delta):
	if $PinJoint2D.node_b != OwnerObject.get_path():
		return
		
	var speed = PullSpeed
	if bInitialImpulse:
		speed *= 10
		ForceUpdateJoint()
		
	if Input.is_action_pressed("Down"):
		IncreaseTongueLength(speed * delta)
	elif Input.is_action_pressed("Up"):
		DecreaseTongueLength(speed * delta)

	else:
		bInitialImpulse = true
	
	
func IncreaseTongueLength(amount):

	ForceUpdateJoint()
	var direction = (OwnerObject.global_position - global_position).normalized()
	OwnerObject.apply_impulse(direction * PullSpeed)
	bInitialImpulse = false
	print($PinJoint2D.length)
	
func DecreaseTongueLength(amount):
	
	ForceUpdateJoint()
	var direction = (OwnerObject.global_position - global_position).normalized()
	OwnerObject.apply_impulse(direction * -PullSpeed)
	bInitialImpulse = false

	print($PinJoint2D.length)
	
func _on_kill_timer_timeout():
	Kill()

func Kill():
	if bIsKilled:
		return
	bIsKilled = true

func ForceUpdateJoint():
	if global_position.distance_to(OwnerObject.global_position) < MaxLength:
		$PinJoint2D.node_b = get_path()
		await get_tree().process_frame
		$PinJoint2D.node_b = OwnerObject.get_path()
