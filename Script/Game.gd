extends Node

class_name Game
var CurrentTime = 0 

signal GameStateUpdate(state)
signal TimeUpdate(amount)
signal CoinIncremented

enum STATE {
	PLAYING,
	GAME_WIN,
	GAME_LOSS	
}

var CurrentState = STATE.PLAYING
var NextScene : PackedScene

func _ready():
	StartGame()
	$AudioStreamPlayer2D.play()
	GameData.StartLevel()
	GameData.LifeAmountChange.connect(OnLifeAmountChange)
	GameData.LifeIncreased.connect(OnLifeIncreased)
	
func OnLifeAmountChange(amount):
	if GameData.IsGameOver():
		var tween = get_tree().create_tween()
		tween.tween_property($AudioStreamPlayer2D, "volume_db", -30, .5)
		tween.tween_property($AudioStreamPlayer2D, "pitch_scale", 0.1, .2)

func OnLifeIncreased():
	$AudioStreamPlayer2D2.play()
	
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
	
func SetNextScene(packedScene):
	NextScene = packedScene
	
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
	
func IncrementCoin():
	emit_signal("CoinIncremented")
	
