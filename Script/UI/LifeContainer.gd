extends HBoxContainer

func _ready():
	GameData.LifeAmountChange.connect(OnLifeAmountChange)
	
	
func OnLifeAmountChange(amount):
	$Label.text = "x" + str(amount)
	
