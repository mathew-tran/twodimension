extends StaticBody2D

@export var NextLevel : PackedScene

func _ready():
	$AnimationPlayer.play("pulse")

func _on_area_2d_area_entered(area):
	GameData.IncreasePoints(1000, global_position)
	Helper.GetGame().WinGame()
	Helper.GetGame().SetNextScene(NextLevel)
