extends HBoxContainer

func _ready():
	GameData.LifeAmountChange.connect(OnLifeAmountChange)
	GameData.LifeIncreased.connect(OnLifeIncreased)
	
func OnLifeAmountChange(amount):
	$Label.text = "x" + str(amount)

func OnLifeIncreased():
	$AnimationPlayer.play("anim")
	
