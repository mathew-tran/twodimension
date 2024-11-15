extends ProgressBar

var bEnabled = false

var bStayUp = false

func _ready():
	Helper.GetGame().GameStateUpdate.connect(OnComplete)
	visible = false
	bEnabled = true
	max_value = $Timer.wait_time
	
func OnComplete(_state):
	visible = true	
	bStayUp = true
	value = 0
	
	
func _process(delta):
	if bEnabled:
		value = $Timer.wait_time - $Timer.time_left
		
func _input(event):
	if bEnabled:
		if event.is_action_pressed("Restart"):
			$Timer.start()
			visible = true
		elif event.is_action_released("Restart"):
			$Timer.stop()
			if bStayUp == false:
				visible = false

func _on_timer_timeout():
	get_tree().reload_current_scene()
