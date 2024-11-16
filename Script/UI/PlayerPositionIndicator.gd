extends Path2D


var SidePaddding = 120
var TopBottomPadding = 120

var WindowSize = Vector2(1920, 1080)
func CreatePoints():
	var windowSize = WindowSize
	var camera = get_viewport().get_camera_2d()
	visible = false
	if camera:
		var center_offset = camera.position
		windowSize /= camera.zoom

		var center_position = Vector2(windowSize.x, windowSize.y) / 2 + center_offset
		position = -center_position
		curve.clear_points()

		curve.add_point(center_position + Vector2(-windowSize.x / 2 + SidePaddding, -windowSize.y / 2 + TopBottomPadding))
		curve.add_point(center_position + Vector2(windowSize.x / 2 - SidePaddding, -windowSize.y / 2 + TopBottomPadding))

		curve.add_point(center_position + Vector2(windowSize.x / 2 - SidePaddding, windowSize.y / 2 - TopBottomPadding))
		curve.add_point(center_position + Vector2(-windowSize.x / 2 + SidePaddding, windowSize.y / 2 - TopBottomPadding))

		curve.add_point(center_position + Vector2(-windowSize.x / 2 + SidePaddding, -windowSize.y / 2 + TopBottomPadding))
		
		print("Window Size: ", windowSize)
		print("Camera Zoom: ", camera.zoom)
		print("Center Position: ", center_position)
func StartAndWait():
	$Timer.start()
	await $Timer.timeout
	
func _init():
	OnHide()
	
func _ready():
	curve.bake_interval = 40.0
	CreatePoints()
	Helper.GetPlayer().GetScreenNotifier().screen_entered.connect(OnHide)
	Helper.GetPlayer().GetScreenNotifier().screen_exited.connect(OnShow)
	
func OnShow():
	CreatePoints()
	await StartAndWait()
	visible = true
	print("show")
	
func OnHide():
	visible = false
	print("hide")
	
func _process(delta):
	
	$Sprite2D.global_position = to_global(curve.get_closest_point(to_local(Helper.GetPlayer().global_position)))
	$Sprite2D.rotation = (Helper.GetPlayer().global_position - $Sprite2D.global_position).normalized().angle()
