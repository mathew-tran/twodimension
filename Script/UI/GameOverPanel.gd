extends Panel

func _ready():
	GameData.LifeAmountChange.connect(OnLifeAmountChange)
	
func OnLifeAmountChange(amount):
	if GameData.IsGameOver():
		$AnimationPlayer.play("new_animation")
