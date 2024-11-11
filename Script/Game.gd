extends Node

class_name Game
var CurrentTime = 0 

signal GameStateUpdate(state)
signal TimeUpdate(amount)

enum STATE {
	PLAYING,
	GAME_WIN,
	GAME_LOSS	
}

var CurrentState = STATE.PLAYING

func _ready():
	StartGame()
	
	
func StartGame():
	$Timer.start()
	
func StopGame():
	$Timer.stop()
	emit_signal("GameStateUpdate", CurrentState)
	
func WinGame():
	if CurrentState != STATE.PLAYING:
		return
	CurrentState = STATE.GAME_WIN
	Helper.GetLevel().SaveData(CurrentTime)
	StopGame()
	
	
func LoseGame():
	if CurrentState != STATE.PLAYING:
		return
	CurrentState = STATE.GAME_LOSS
	StopGame()

func GetTime():
	return CurrentTime
	
func _on_timer_timeout():
	CurrentTime += $Timer.wait_time
	emit_signal("TimeUpdate", CurrentTime)
