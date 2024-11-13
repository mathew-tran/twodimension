extends RigidBody2D


var Eyes = []

var MoveSpeed = 800
var MaxLength = 1200
@onready var TongueEndClass = preload("res://Prefab/TongueEnd.tscn")
var TongueEndRef = null

var bCanMove = true

var SFX = [
	"res://Audio/cute_01.ogg",
	"res://Audio/cute_02.ogg",
	"res://Audio/cute_03.ogg",
	"res://Audio/cute_04.ogg",
	"res://Audio/cute_05.ogg",
	"res://Audio/cute_06.ogg",
	"res://Audio/cute_07.ogg",
	"res://Audio/cute_08.ogg",
	"res://Audio/cute_09.ogg",
	"res://Audio/cute_10.ogg",
]

func _ready():
	Eyes.append($Eye1)
	Eyes.append($Eye2)
	Helper.GetGame().GameStateUpdate.connect(OnStateUpdate)

func OnStateUpdate(state):
	bCanMove = false
	if state == Game.STATE.GAME_WIN:
		freeze = true
		for child in get_children():
			if child is RigidBody2D:
				child.freeze = true
				
		if HasTongue():
			TongueEndRef.bEnabled = false
		$GruntSFX.play()
	elif state == Game.STATE.GAME_LOSS:
		freeze = false	
		RevertTongue()
	
func UpdateEyes(delta):
	for eye in Eyes:
		if eye:
			eye.look_at(get_global_mouse_position())	
	
func _process(delta):
	if bCanMove:
		UpdateEyes(delta)		
		
	
func _physics_process(delta):
	if bCanMove:
		Move(delta)
		
func IsConnected():
	return 
		
func Move(delta):
	var multiplier = 1
	if HasTongue():
		multiplier *= 2
	if Input.is_action_pressed("MoveLeft"):
		apply_impulse(Vector2.LEFT * MoveSpeed * delta * multiplier)
	if Input.is_action_pressed("MoveRight"):
		apply_impulse(Vector2.RIGHT * MoveSpeed * delta * multiplier)

func CanUseTongue():
	return $TongueCooldown.time_left == 0.0
	
func HasTongue():
	return is_instance_valid(TongueEndRef)
	
func _input(event):
	if bCanMove == false:
		return
		
	if event.is_action_pressed("Detach") and CanUseTongue():
		RevertTongue()
		
	if Input.is_action_just_released("Click"):
		RevertTongue()
		
	if Input.is_action_pressed("Click") and CanUseTongue() and HasTongue() == false:
		$TongueCooldown.start()
		RevertTongue()
		AttemptSound()
		
		var direction = to_local(get_global_mouse_position()).normalized()
		$RayCast2D.target_position = direction * MaxLength
		$RayCast2D.force_raycast_update()
		
		TongueEndRef = TongueEndClass.instantiate()
		TongueEndRef.OwnerObject = self
		TongueEndRef.MaxLength = MaxLength
		get_parent().add_child(TongueEndRef)
		$AudioStreamPlayer2D.play()
		if $RayCast2D.is_colliding():			
			TongueEndRef.global_position = $RayCast2D.get_collision_point()
			TongueEndRef.get_node("PinJoint2D").node_b = get_path()
			angular_velocity = 0
			$RayCast2D.enabled = false
			TongueEndRef.EmitParticle()
		else:
			TongueEndRef.global_position = to_global($RayCast2D.target_position)
		
func RevertTongue():
	$RayCast2D.target_position = Vector2.ZERO

	$RayCast2D.force_raycast_update()
	if is_instance_valid(TongueEndRef):
		TongueEndRef.Kill()


func _on_tongue_cooldown_timeout():
	if IsConnected() == false:
		RevertTongue()
		$RayCast2D.enabled = true

func IsOverlapping():
	var bodies = $CollisionChecker.get_overlapping_bodies()
	if bodies:
		if bodies.size() > 1:
			return true
	return false

func AttemptSound():
	var result = randi() % 100
	if result > 50:
		return
		
	if $GruntTimer.time_left == 0.0:
		
		SFX.shuffle()
		$GruntSFX.stream = load(SFX[0])
		$GruntSFX.play()
		$GruntTimer.wait_time = randf_range(20, 40)
		$GruntTimer.start()
		var mouthResult = randi_range(0 ,2)
		if mouthResult == 0:
			$Mouth.scale = Vector2(.4,.4)
		elif mouthResult == 1:
			$Mouth.scale = Vector2(.4,.6)
		elif mouthResult == 2:
			$Mouth.scale = Vector2(.6,.4)
			
func _on_collision_checker_body_entered(body):
	AttemptSound()



func _on_grunt_sfx_finished():
	$Mouth.scale = Vector2(.2,.2)
