extends Control

@onready var resume_button: TextureButton = $"VBoxContainer/Resume Button"
@onready var quit_button: TextureButton = $"VBoxContainer/Quit Button"
@onready var confirm_quit: Panel = $ConfirmQuit
@onready var yes_button: TextureButton = $"ConfirmQuit/VBoxContainer/HBoxContainer/Yes Button"
@onready var no_button: TextureButton = $"ConfirmQuit/VBoxContainer/HBoxContainer/No Button"

const LABEL_NORMAL_Y = -8.0
const LABEL_PRESSED_Y = -3.0

var resume_pressed: bool = false
var exit_pressed: bool = false
var yes_pressed: bool = false
var no_pressed: bool = false

var times_played = 0

func pause_or_resume():
	if !self.visible: # if not paused
		AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Master"), 0, true)  # pause
		get_tree().paused = true
	else:
		AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Master"), 0, false) # resume
		get_tree().paused = false
		
	self.visible = !self.visible
		
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		pause_or_resume()

func _ready():
	confirm_quit.visible = false

func on_button_up(button: Control) -> void:
	button.get_node('RichTextLabel').position.y = LABEL_NORMAL_Y
	
func on_button_down(button: Control) -> void:
	button.get_node('RichTextLabel').position.y = LABEL_PRESSED_Y	

func _on_start_button_button_up() -> void:
	on_button_up(resume_button)
	resume_pressed = false

func _on_start_button_button_down() -> void:
	on_button_down(resume_button)
	resume_pressed = true

func _on_start_button_mouse_entered():
	if resume_pressed:
		on_button_down(resume_button)
	
func _on_start_button_mouse_exited():
	on_button_up(resume_button)
	
func _on_quit_button_pressed() -> void:
	confirm_quit.visible = true

func _on_quit_button_button_down() -> void:
	on_button_down(quit_button)
	exit_pressed = true

func _on_quit_button_button_up() -> void:
	on_button_up(quit_button)
	exit_pressed = false

func _on_quit_button_mouse_entered():
	if exit_pressed:
		on_button_down(quit_button)
	
func _on_quit_button_mouse_exited():
	on_button_up(quit_button)
	
func _on_start_button_pressed() -> void:
	pause_or_resume()

func _on_yes_button_pressed() -> void:
	pause_or_resume()
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _on_no_button_pressed() -> void:
	confirm_quit.visible = false

func _on_yes_button_button_down() -> void:
	on_button_down(yes_button)
	yes_pressed = true

func _on_yes_button_button_up() -> void:
	on_button_up(yes_button)
	yes_pressed = false

func _on_yes_button_mouse_entered() -> void:
	if yes_pressed:
		on_button_down(yes_button)

func _on_yes_button_mouse_exited() -> void:
	on_button_up(yes_button)

func _on_no_button_button_down() -> void:
	on_button_down(no_button)
	no_pressed = true

func _on_no_button_button_up() -> void:
	on_button_up(no_button)
	no_pressed = false

func _on_no_button_mouse_entered() -> void:
	if no_pressed:
		on_button_down(no_button)

func _on_no_button_mouse_exited() -> void:
	on_button_up(no_button)
