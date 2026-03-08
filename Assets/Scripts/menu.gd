extends Control

@onready var confirmation_dialog: ConfirmationDialog = $ConfirmationDialog


const LABEL_NORMAL_Y = -8.0
const LABEL_PRESSED_Y = -3.0

var start_pressed: bool = false
var exit_pressed: bool = false

func _ready():
	$"VBoxContainer/Start Button".button_down.connect(_on_start_button_down)
	$"VBoxContainer/Start Button".button_up.connect(_on_start_button_up)
	$"VBoxContainer/Start Button".mouse_entered.connect(_on_start_button_mouse_entered)
	$"VBoxContainer/Start Button".mouse_exited.connect(_on_start_button_mouse_exited)
	
	$"VBoxContainer/Quit Button".button_down.connect(_on_quit_button_down)
	$"VBoxContainer/Quit Button".button_up.connect(_on_quit_button_up)
	$"VBoxContainer/Quit Button".mouse_entered.connect(_on_quit_button_mouse_entered)
	$"VBoxContainer/Quit Button".mouse_exited.connect(_on_quit_button_mouse_exited)

func _on_start_button_down():
	$"VBoxContainer/Start Button"/RichTextLabel.position.y = LABEL_PRESSED_Y
	start_pressed = true

func _on_start_button_up():
	$"VBoxContainer/Start Button"/RichTextLabel.position.y = LABEL_NORMAL_Y
	start_pressed = false

func _on_start_button_mouse_entered():
	if start_pressed:
		$"VBoxContainer/Start Button"/RichTextLabel.position.y = LABEL_PRESSED_Y
	
func _on_start_button_mouse_exited():
	$"VBoxContainer/Start Button"/RichTextLabel.position.y = LABEL_NORMAL_Y
	
func _on_quit_button_down():
	$"VBoxContainer/Quit Button"/RichTextLabel.position.y = LABEL_PRESSED_Y
	start_pressed = true

func _on_quit_button_up():
	$"VBoxContainer/Quit Button"/RichTextLabel.position.y = LABEL_NORMAL_Y
	start_pressed = false

func _on_quit_button_mouse_entered():
	if start_pressed:
		$"VBoxContainer/Quit Button"/RichTextLabel.position.y = LABEL_PRESSED_Y
	
func _on_quit_button_mouse_exited():
	$"VBoxContainer/Quit Button"/RichTextLabel.position.y = LABEL_NORMAL_Y
	
	
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


func _on_quit_button_pressed() -> void:
	confirmation_dialog.popup_centered()

func _on_confirmation_dialog_confirmed():
	get_tree().quit()
