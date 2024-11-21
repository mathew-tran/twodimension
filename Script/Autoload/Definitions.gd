extends Node

var bIsDebug = true

var DebugLevel = "res://Scenes/Forest/Level4.tscn"

func _ready():
	if bIsDebug == false: 
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	
	if DebugLevel != "" and bIsDebug:
		get_tree().change_scene_to_packed(load(DebugLevel))
