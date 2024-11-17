extends HBoxContainer


var Index = 0

func _init():
	visible = false
func _ready():
	for child in get_children():
		child.queue_free()
	
	if Helper.GetCoins() != null:
		for coin in Helper.GetCoins().size():
			var instance = load("res://Prefab/UI/CoinFillIn.tscn").instantiate()
			add_child(instance)
		
	Helper.GetGame().CoinIncremented.connect(OnCoinAdded)
	await get_tree().process_frame
	visible = true
	
func OnCoinAdded():
	get_child(Index).ShowCoin()
	Index += 1
	
