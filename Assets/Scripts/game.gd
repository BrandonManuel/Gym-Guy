extends Node

var letter = preload("res://Scenes/letter.tscn")
var keyboard_keys: Node = null

func start(player: CharacterBody2D):
	print("game started")
#	TODO remove these calls to lift() and start working on actual minigame logic for these calls (also remove await which was just here for testing)
	lift(player)
	
func lift(player: CharacterBody2D):
	var score_menu = get_tree().get_root().find_child("ScoreMenu", true, false)
	var score = score_menu.score
	var success = true
	var num_keys = 1
	if score > 5:
		num_keys = 2
		
	if score > 10: 
		num_keys = 3
	
	if score > 15:
		num_keys = 4
		
	if score > 20:
		num_keys = 5
	
	if keyboard_keys == null:
			keyboard_keys = get_tree().get_root().find_child("Keyboard Keys", true, false)
		
	for i in range(num_keys - keyboard_keys.get_child_count()):
		var instance = letter.instantiate()
		var sprite: Sprite2D = instance.get_node('Sprite2D')
		sprite.frame = randf_range(0, 25)
		keyboard_keys.add_child(instance)
		
	if !success:
		return
		
	print('setting animation to curling')
	player.get_node('Visual').get_node('AnimationPlayer').play('curling')
	player.is_lifting.emit('curling')
	score_menu.increment()
