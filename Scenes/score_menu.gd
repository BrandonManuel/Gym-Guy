extends Control
@onready var score_text: Label = $VBoxContainer/Score

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func increment() -> void:
	if !self.visible:
		self.visible = true
		
	score += 1
	score_text.text = "Score: %d" % score
