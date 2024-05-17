class_name Vortex
extends CharacterBody3D


@export var speed: float = 2
@export var target: CharacterBody3D


func _physics_process(delta):
	var collision_info = move_and_collide(velocity * speed * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
		

func random_velocity() -> Vector3:
	return  (transform.basis * Vector3(randf() - 0.5, 0, randf() - 0.5).normalized())
	
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		Signals.emit_signal("player_destroyed", body)
		return
		
	if body.is_in_group("Platforms"):
		Signals.emit_signal("platform_destroyed", body)
		return
