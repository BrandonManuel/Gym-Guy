extends Node
@onready var player: CharacterBody2D = $Player
@onready var game_area: Node2D = $"Game Area"
@onready var keyboard_keys: HBoxContainer = $"Game Area/Keyboard Keys"
@onready var progress_bar: ProgressBar = $"Game Area/ProgressBar"
@onready var game_text: Label = $"Game Area/GameText"
@onready var x_container: HBoxContainer = $"Game Area/XContainer"

@export var audio_list: Array[AudioStreamWAV]
@onready var sound_effects: AudioStreamPlayer = $"Sound Effects"

@onready var gym_floor_music: AudioStreamPlayer = $"Gym Floor Music"

enum sfx {
	CORRECT_LETTER, INCORRECT_LETTER, LIFT
}

const num_allowed_strikes = 3

var letter = preload("res://Scenes/letter.tscn")
var strike = preload("res://Scenes/x.tscn")
var num_strikes = 0
var score_menu = null 
var currentIndex = 0
var keysToPress = []
var roundStarted = false
var timer_value: float = 5.0
var tween: Tween = null

signal save_game
signal load_game

func start():
	load_game.emit()
	player.get_node('Visual').get_node('AnimationPlayer').play('idle (back)')
	player.is_walking.emit('idle (back)')
	
	currentIndex = 0
	num_strikes = 0
	
	game_text.text = "Get Ready to Type!"
	game_text.visible = true
	await get_tree().create_timer(2.0).timeout
	game_text.visible = false
	
	setupLetters()
	keyboard_keys.visible = true
	progress_bar.visible = true
	progress_bar.value = 100
	
	
	tween = create_tween()
	tween.tween_property(progress_bar, "value", 0, timer_value)
	roundStarted = true
	
func _process(delta: float) -> void:
	if roundStarted:
		if progress_bar != null and progress_bar.value <= 0:
			print("out of time idiot")

func setupLetters():
	player.play_idle_back()
	player.get_node('Visual').get_node('AnimationPlayer').queue('idle (back)')
	if score_menu == null:
		score_menu = get_tree().get_root().find_child("ScoreMenu", true, false)
	
	var score = 0
	if score_menu != null:
		score_menu.init()
		score_menu.visible = true
		score = score_menu.score
		
	var num_keys = 1
	if score >= 5:
		num_keys = 2
		
	if score >= 10: 
		num_keys = 3
	
	if score >= 15:
		num_keys = 4
		
	if score >= 20:
		num_keys = 5
	
		
	for i in range(num_keys - keyboard_keys.get_child_count()):
		var instance = letter.instantiate()
		var not_pressed: Sprite2D = instance.get_node("Polygon2D").get_node('Not Pressed')
		var pressed: Sprite2D = instance.get_node("Polygon2D").get_node('Pressed')
		var frame = randi_range(0, 25)
		not_pressed.frame = frame
		pressed.frame = frame
		var letterKey = Util.LETTERS[frame]
		keysToPress.push_back(letterKey)
		keyboard_keys.add_child(instance)
	
	set_current_outline(true)

func set_current_outline(flag: bool):
	var key = keyboard_keys.get_child(currentIndex)
	key.enable_current(flag)
	
func set_correct_outline(flag: bool):
	var key = keyboard_keys.get_child(currentIndex)
	key.enable_correct(flag)
	
func _input(event: InputEvent) -> void:
	if roundStarted and event is InputEventKey and event.is_pressed():
		var letter = char(event.keycode)
		if !keysToPress.is_empty():
			var keyToPress = keysToPress[currentIndex]
			if keyToPress == letter:
				keyboard_keys.get_child(currentIndex).get_node("Polygon2D").get_node("Not Pressed").visible = false
				keyboard_keys.get_child(currentIndex).get_node("Polygon2D").get_node("Pressed").visible = true
	
	if roundStarted and event is InputEventKey and event.is_released():
		var letter = char(event.keycode)
		if !keysToPress.is_empty():
			var keyToPress = keysToPress[currentIndex]
			if keyToPress == letter:
				keyboard_keys.get_child(currentIndex).get_node("Polygon2D").get_node("Not Pressed").visible = true
				keyboard_keys.get_child(currentIndex).get_node("Polygon2D").get_node("Pressed").visible = false
				set_current_outline(false)
				set_correct_outline(true)
				currentIndex += 1
				sound_effects.stream = audio_list[sfx.CORRECT_LETTER]
				sound_effects.play()
				if currentIndex < keysToPress.size():
					set_current_outline(true)
				else:
					roundStarted = false
					tween.pause()
					score_menu.increment()
					print('setting animation to curling')
					player.get_node('Visual').get_node('AnimationPlayer').play('curling')
					player.is_lifting.emit('curling')
					sound_effects.stream = audio_list[sfx.LIFT]
					sound_effects.play()
					await get_tree().create_timer(1.4667).timeout
					for n in keyboard_keys.get_children():
						keyboard_keys.remove_child(n)
						n.queue_free()
						
					keysToPress = []
					currentIndex = 0
					setupLetters()
					
					progress_bar.value = 100
					timer_value = 5.0
					tween = create_tween()
					tween.tween_property(progress_bar, "value", 0, timer_value)
					roundStarted = true
					player.is_walking.emit('idle (back)')
			else:
				num_strikes += 1
				sound_effects.stream = audio_list[sfx.INCORRECT_LETTER]
				sound_effects.play()
				var strike_instance = strike.instantiate()
				strike_instance.custom_minimum_size = Vector2(16, 16)
				x_container.add_child(strike_instance)
				if num_strikes >= num_allowed_strikes:
					save_game.emit()
					roundStarted = false
					keyboard_keys.queue_free()
					progress_bar.queue_free()
					gym_floor_music.stop()
					player.get_node('Visual').get_node('AnimationPlayer').pause()
					player.is_lifting.emit('STOP')
					await get_tree().create_timer(2.0).timeout
					game_text.text = "You Lose!"
					game_text.visible = true
					await get_tree().create_timer(3.0).timeout
					get_tree().change_scene_to_file("res://Scenes/menu.tscn")
