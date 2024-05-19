extends Control

@export var start_button: Button
@export var quit_button: Button


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
