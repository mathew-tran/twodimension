extends RigidBody2D


var Eyes = []

var MoveSpeed = 400

@onready var TongueEndClass = preload("res://Prefab/TongueEnd.tscn")
var TongueEndRef = null

func _ready():
	Eyes.append($Eye1)
	Eyes.append($Eye2)


func UpdateEyes(delta):
	for eye in Eyes:
		if eye:
			eye.look_at(get_global_mouse_position())	
	
func _process(delta):
	UpdateEyes(delta)		
	
func _physics_process(delta):
	Move(delta)
		
func IsConnected():
	return 
		
func Move(delta):
	if Input.is_action_pressed("MoveLeft"):
		apply_impulse(Vector2.LEFT * MoveSpeed * delta)
	if Input.is_action_pressed("MoveRight"):
		apply_impulse(Vector2.RIGHT * MoveSpeed * delta)

func CanUseTongue():
	return $TongueCooldown.time_left == 0.0
	
func _input(event):
	if event.is_action_pressed("Detach") and CanUseTongue():
		RevertTongue()
		
	if Input.is_action_just_released("Click"):
		RevertTongue()
		
	if Input.is_action_just_pressed("Click") and CanUseTongue():
		print("revert-click")
		$TongueCooldown.start()
		RevertTongue()
		
		var direction = to_local(get_global_mouse_position()).normalized()
		$RayCast2D.target_position = direction * 1200
		$RayCast2D.force_raycast_update()
		
		TongueEndRef = TongueEndClass.instantiate()
		TongueEndRef.OwnerObject = self
		get_parent().add_child(TongueEndRef)
		if $RayCast2D.is_colliding():			
			TongueEndRef.global_position = $RayCast2D.get_collision_point()
			TongueEndRef.get_node("PinJoint2D").node_b = get_path()
			angular_velocity = 0
			$RayCast2D.enabled = false
		else:
			TongueEndRef.IntendedPosition = global_position
			TongueEndRef.global_position = get_global_mouse_position()
			
func RevertTongue():
	print("reverted")
	$RayCast2D.target_position = Vector2.ZERO

	$RayCast2D.force_raycast_update()
	if is_instance_valid(TongueEndRef):
		TongueEndRef.Kill()


func _on_tongue_cooldown_timeout():
	if IsConnected() == false:
		RevertTongue()
		$RayCast2D.enabled = true
