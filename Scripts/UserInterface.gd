extends Control

@export var score_label: RichTextLabel
var current_score: int = 0

func _ready() -> void:
	Signals.connect("platform_destroyed", update_score)

func update_score(body) -> void:
	current_score += 1
	print("Current score: ", current_score)
	score_label.text = str("Score:  ", current_score)
