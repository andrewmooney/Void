class_name Platform
extends RigidBody3D
@export var timer: Timer
@export var animation_player: AnimationPlayer

var has_collided: bool = false
@onready var moving_enabled: bool = false
@onready var falling_enabled: bool = true

func _ready() -> void:
	lock_rotation = true
	freeze = true
	gravity_scale = 1


func collide_with():
	has_collided = true
	timer.start()


func _on_timer_timeout() -> void:
	freeze = false


func _on_area_3d_body_entered(body: Node3D) -> void:
	if falling_enabled:
		collide_with()
