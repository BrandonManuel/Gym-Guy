extends Control
@onready var score_text: Label = $VBoxContainer/Score

var score = 0
var high_score = 0

func init() -> void:
	if !self.visible:
		self.visible = true
	
	score_text.text = "Score: %d" % score
	score_text.text += "\nHigh Score: %d" % high_score
	
func increment() -> void:
	if !self.visible:
		self.visible = true
		
	score += 1
	if score > high_score:
		high_score = score
		
	score_text.text = "Score: %d" % score
	score_text.text += "\nHigh Score: %d" % high_score
