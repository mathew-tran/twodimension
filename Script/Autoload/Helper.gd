extends Node

func GetGame() -> Game:
	var result = get_tree().get_nodes_in_group("Game")
	if result:
		return result[0]
	return null

func GetLevel() -> Level:
	var result = get_tree().get_nodes_in_group("Level")
	if result:
		return result[0]
	return null

func GetPlayer() -> Player:
	var result = get_tree().get_nodes_in_group("Player")
	if result:
		return result[0]
	return null

func GetCoins():
	var result = get_tree().get_nodes_in_group("Coin")
	if result:
		return result
	return null
