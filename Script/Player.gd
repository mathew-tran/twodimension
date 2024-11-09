extends RigidBody2D


var Eyes = []

var InitialTonguePosition = Vector2.ZERO

var TongueSpeed = 1200
var MaxTongueSpeed = 3000

var MoveSpeed = 400



func _ready():
	Eyes.append($Eye1)
	Eyes.append($Eye2)
	InitialTonguePosition = $Line2D.points[1]


func UpdateEyes(delta):
	for eye in Eyes:
		if eye:
			eye.look_at(get_global_mouse_position())	
	return
	
func _process(delta):
	UpdateEyes(delta)
	if IsConnected():
		MoveWithTongueConnected(delta)
	else:
		Move(delta)
	
func IsConnected():
	return $RayCast2D.is_colliding()
	
func MoveWithTongueConnected(delta):
	if IsConnected():

		if global_position.distance_to($RayCast2D.get_collision_point()) < 100:
			RevertTongue()
			return
		global_position = global_position.move_toward($RayCast2D.get_collision_point(), delta * TongueSpeed)
		linear_velocity = Vector2.ZERO
		gravity_scale = 0
		$Line2D.points[1] = to_local($RayCast2D.get_collision_point())
		
func Move(delta):
	if Input.is_action_pressed("MoveLeft"):
		apply_impulse(Vector2.LEFT * MoveSpeed * delta)
	if Input.is_action_pressed("MoveRight"):
		apply_impulse(Vector2.RIGHT * MoveSpeed * delta)

func CanUseTongue():
	return $TongueCooldown.time_left == 0.0
	
func _input(event):
	if event.is_action_pressed("Detach") and IsConnected():
		RevertTongue()
		
	if event.is_action_pressed("Click") and CanUseTongue():
		$TongueCooldown.start()
		rotation_degrees = 0
		TongueSpeed = linear_velocity.length()
		if TongueSpeed > MaxTongueSpeed:
			TongueSpeed = MaxTongueSpeed
			
		await  get_tree().process_frame
		var direction = to_local(get_global_mouse_position()).normalized()
		$RayCast2D.target_position = direction * 5200
		$RayCast2D.force_raycast_update()
		if IsConnected():
			$Line2D.points[1] = to_local($RayCast2D.get_collision_point())
		else: 
			$Line2D.points[1] = direction * 5200
			$RayCast2D.target_position = Vector2.ZERO
			$RayCast2D.force_raycast_update()
			$RayCast2D.enabled = false
			
func RevertTongue():
	$RayCast2D.target_position = Vector2.ZERO
	$Line2D.points[1] = InitialTonguePosition
	$RayCast2D.force_raycast_update()
	gravity_scale = 1


func _on_tongue_cooldown_timeout():
	if IsConnected() == false:
		RevertTongue()
		$RayCast2D.enabled = true
