extends Node

var bIsDebug = false


func _ready():
	if bIsDebug == false:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
