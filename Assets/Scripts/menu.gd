extends Control

@onready var confirmation_dialog: ConfirmationDialog = $ConfirmationDialog
@onready var start_button: TextureButton = $"VBoxContainer/Start Button"
@onready var quit_button: TextureButton = $"VBoxContainer/Quit Button"
@onready var title_music: AudioStreamPlayer = $"Title Music"

const LABEL_NORMAL_Y = -8.0
const LABEL_PRESSED_Y = -3.0

var start_pressed: bool = false
var exit_pressed: bool = false

var times_played = 0

func _ready():
	start_button.button_down.connect(_on_start_button_down)
	start_button.button_up.connect(_on_start_button_up)
	start_button.mouse_entered.connect(_on_start_button_mouse_entered)
	start_button.mouse_exited.connect(_on_start_button_mouse_exited)
	
	quit_button.button_down.connect(_on_quit_button_down)
	quit_button.button_up.connect(_on_quit_button_up)
	quit_button.mouse_entered.connect(_on_quit_button_mouse_entered)
	quit_button.mouse_exited.connect(_on_quit_button_mouse_exited)

func _on_start_button_down():
	start_button.get_node('RichTextLabel').position.y = LABEL_PRESSED_Y
	start_pressed = true

func _on_start_button_up():
	start_button.get_node('RichTextLabel').position.y = LABEL_NORMAL_Y
	start_pressed = false

func _on_start_button_mouse_entered():
	if start_pressed:
		start_button.get_node('RichTextLabel').position.y = LABEL_PRESSED_Y
	
func _on_start_button_mouse_exited():
	start_button.get_node('RichTextLabel').position.y = LABEL_NORMAL_Y
	
func _on_quit_button_down():
	quit_button.get_node('RichTextLabel').position.y = LABEL_PRESSED_Y
	start_pressed = true

func _on_quit_button_up():
	quit_button.get_node('RichTextLabel').position.y = LABEL_NORMAL_Y
	start_pressed = false

func _on_quit_button_mouse_entered():
	if start_pressed:
		quit_button.get_node('RichTextLabel').position.y = LABEL_PRESSED_Y
	
func _on_quit_button_mouse_exited():
	quit_button.get_node('RichTextLabel').position.y = LABEL_NORMAL_Y
	
	
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


func _on_quit_button_pressed() -> void:
	confirmation_dialog.popup_centered()

func _on_confirmation_dialog_confirmed():
	get_tree().quit()


func _on_title_music_finished() -> void:
	times_played += 1
	if times_played < 2:
		title_music.play(0)
