extends Button


func _on_button_up():
	GameData.Setup()
	get_tree().change_scene_to_packed(load("res://Scenes/Forest/Level1.tscn"))
