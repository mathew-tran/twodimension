extends Node

var bIsDebug = true

func _ready():
	if bIsDebug == false: 
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
