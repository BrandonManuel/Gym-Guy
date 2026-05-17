extends Node

@onready var score_menu: Control = $"../CanvasLayer/ScoreMenu"

func save_game():
	var saved_game:SavedGame = SavedGame.new()
	saved_game.high_score = score_menu.high_score
	
	ResourceSaver.save(saved_game, "user://savegame.tres")
	
func load_game():
	var saved_game:SavedGame = load("user://savegame.tres")
	if saved_game != null:
		score_menu.high_score = saved_game.high_score
	
func _on_gym_save_game() -> void:
	save_game()

func _on_gym_load_game() -> void:
	load_game()
