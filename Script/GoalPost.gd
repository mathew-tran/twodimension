extends StaticBody2D


func _ready():
	$AnimationPlayer.play("pulse")

func _on_area_2d_area_entered(area):
	Helper.GetGame().WinGame()
