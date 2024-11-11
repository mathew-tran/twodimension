extends Node2D

class_name Level

var LevelName
var SavePath = "user://save_data.json"

var Data = {}

var bHasBeatenOldTime = false

func _ready():
	add_to_group("Level")
	LevelName = get_tree().current_scene.scene_file_path.split("/")[-1].split(".tscn")[0]
	LoadData()
	
func HasData():
	return Data.has(LevelName)
	
func GetLevelTime():
	return Data[LevelName]
	
func LoadData():
	if FileAccess.file_exists(SavePath):
		var file = FileAccess.open(SavePath, FileAccess.READ)
		Data = file.get_var(true)
		file.close()
	else:
		Data = {"startDate" : Time.get_date_dict_from_system()}
	
func SaveData(timeAmount):
	if HasData():
		if Data[LevelName] > timeAmount:
			Data[LevelName] = timeAmount
			bHasBeatenOldTime = true
	else:
		Data[LevelName] = timeAmount
		bHasBeatenOldTime = true
	var file = FileAccess.open(SavePath, FileAccess.WRITE)
	file.store_var(Data)
	file.close()
