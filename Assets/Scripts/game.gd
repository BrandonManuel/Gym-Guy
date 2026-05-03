extends Node

var letter = preload("res://Scenes/letter.tscn")
var keyboard_keys: Node = null
var score_menu = null
var currentIndex = 0
var keysToPress = []
var roundStarted = false
var player = null

func start(player: CharacterBody2D):
	print("game started")
	self.player = player
	player.get_node('Visual').get_node('AnimationPlayer').play('idle (back)')
	player.is_walking.emit('idle (back)')
	setupLetters()
	await get_tree().create_timer(2.0).timeout
	roundStarted = true
	
func setupLetters():
	player.play_idle_back()
	player.get_node('Visual').get_node('AnimationPlayer').queue('idle (back)')
	if score_menu == null:
		score_menu = get_tree().get_root().find_child("ScoreMenu", true, false)
		
	var score = score_menu.score
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
		sprite.frame = randi_range(0, 25)
		var letterKey = Util.LETTERS[sprite.frame]
		keysToPress.push_back(letterKey)
		keyboard_keys.add_child(instance)
		

func _input(event: InputEvent) -> void:
	if roundStarted and event is InputEventKey and event.is_pressed():
		var letter = char(event.keycode)
		if !keysToPress.is_empty():
			var keyToPress = keysToPress[currentIndex]
			if keyToPress == letter:
				currentIndex += 1
				if currentIndex >= keysToPress.size():
					roundStarted = false
					score_menu.increment()
					for n in keyboard_keys.get_children():
						keyboard_keys.remove_child(n)
						n.queue_free()
					keysToPress = []
					setupLetters()
					print('setting animation to curling')
					player.get_node('Visual').get_node('AnimationPlayer').play('curling')
					player.is_lifting.emit('curling')
					currentIndex = 0
					await get_tree().create_timer(1.4667).timeout
					roundStarted = true
					player.is_walking.emit('idle (back)')
			else:
				print("YOU LOSE")
