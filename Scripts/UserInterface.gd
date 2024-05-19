extends Control

@export var score_label: RichTextLabel
@export var high_score_label: Label
@export var jump_label: RichTextLabel
@export var dash_progress: ProgressBar
@export var timer: Timer

var default_score_increment: int = 1
var score_increment: int
var current_score: int = 0
var multiplier_active: bool = false
var high_score: int = 0
const FILE_PATH: String = "user://game_data.save"

func _ready() -> void:
	score_increment = default_score_increment
	load_data()
	Signals.connect("platform_destroyed", update_score)
	Signals.connect("double_jump_enabled", jump_enabled)
	Signals.connect("dash_energy_level", dash_level)
	Signals.connect("item_collected", score_multiplier)
	Signals.connect("player_destroyed", save_data)


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
	if current_score > high_score:
		high_score = current_score
		high_score_label.text = str("High Score", high_score)
		


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
	
func save_data(body: Player) -> void:
	print("IN SAVE")
	if current_score >= high_score:
		print("Saving")
		var save_data = {
			"score": high_score
		}
		var save_game = FileAccess.open(FILE_PATH, FileAccess.WRITE)
		
		save_game.store_line(JSON.stringify(save_data))
		

func load_data() -> void:
	if FileAccess.file_exists(FILE_PATH):
		var load_data = FileAccess.open(FILE_PATH, FileAccess.READ)
		while load_data.get_position() < load_data.get_length():
			var json_string = load_data.get_line()
			var json = JSON.new()
			var parsed_data = json.parse(json_string)
			print(parsed_data)
			high_score = json.get_data().score
			high_score_label.text = str("High Score", high_score)
	
