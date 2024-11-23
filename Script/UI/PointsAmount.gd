extends Label

func _ready():
	GameData.PointsChange.connect(OnPointsChange)
	
func OnPointsChange(amount):
	text = str(amount).pad_zeros(6)
