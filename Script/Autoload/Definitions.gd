extends Node

var bIsDebug = true

func _ready():
	if bIsDebug == false:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
