extends Label


func _ready():
	Helper.GetGame().TimeUpdate.connect(OnTimeUpdate)
	
func OnTimeUpdate(amount):
	text = str(amount).pad_decimals(2)
