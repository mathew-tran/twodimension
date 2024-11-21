extends Label


func _ready():
	Helper.GetGame().TimeUpdate.connect(OnTimeUpdate)
	Helper.GetGame().GameStateUpdate.connect(OnStateUpdate)
	
	
func OnTimeUpdate(amount):
	text = str(amount).pad_decimals(2)

func OnStateUpdate(state):
	if state == Game.STATE.GAME_WIN:
		if Helper.GetLevel().bHasBeatenOldTime:
			modulate = Color.GREEN
			text += "\n New Record!!!"
		else:
			text += "\n Best Time: " + str(Helper.GetLevel().GetLevelTime()).pad_decimals(2)
