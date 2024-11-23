extends Node

var Lives = 3
var CurrentPointsToMaxLife = 0
var TotalPoints = 0

var PointsToMaxLife = 1000

signal LifeAmountChange(amount)
signal PointsChange(amount)

func IncreasePoints(amount):
	TotalPoints += amount
	CurrentPointsToMaxLife += amount
	while CurrentPointsToMaxLife >= PointsToMaxLife:
		CurrentPointsToMaxLife -= PointsToMaxLife
		Lives += 1
		LifeAmountChange.emit(Lives)
	
	PointsChange.emit(TotalPoints)
	
func RemoveLife():
	Lives -= 1
	LifeAmountChange.emit(Lives)
	
func IsGameOver():
	return Lives <= 0
	
func Setup():
	CurrentPointsToMaxLife = 0
	TotalPoints = 0
	Lives = 3
	
	StartLevel()

func StartLevel():
	LifeAmountChange.emit(Lives)	
	PointsChange.emit(TotalPoints)
