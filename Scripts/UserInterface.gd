extends Control

@export var score_label: RichTextLabel
@export var jump_label: RichTextLabel
@export var dash_progress: ProgressBar
@export var timer: Timer

var default_score_increment: int = 1
var score_increment: int
var current_score: int = 0
var multiplier_active: bool = false

func _ready() -> void:
	score_increment = default_score_increment
	Signals.connect("platform_destroyed", update_score)
	Signals.connect("double_jump_enabled", jump_enabled)
	Signals.connect("dash_energy_level", dash_level)
	Signals.connect("item_collected", score_multiplier)
	
func score_multiplier(item: String):
	multiplier_active = true
	score_increment *= 3
	timer.wait_time = 5
	timer.start()

func update_score(body) -> void:
	current_score += score_increment
	print("Current score: ", current_score)
	print("Current multiplier: ", multiplier_active)
	score_label.text = str("Score:  ", current_score)

func jump_enabled(double_jump: bool):
	jump_label.text  = "Double Jump Active"
	if !double_jump:
		jump_label.hide()
		return
	jump_label.show()
	
func dash_level(dash_energy: float):
	dash_progress.value = dash_energy


func _on_timer_timeout() -> void:
	multiplier_active = false
	score_increment = default_score_increment
