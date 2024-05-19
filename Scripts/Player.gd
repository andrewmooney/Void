class_name Player
extends CharacterBody3D

const dash_energy_max: float = 100.0
var jump_velocity: float = 5.0

var speed: float = 5.0

var dash_energy: float = 100.0
var dash_enabled: bool = true
var dash_energy_increment: float = 0.2
var double_jump: bool = true

@onready var spring_arm: SpringArm3D = $SpringArm3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	
	Signals.connect("item_collected", new_item_collected)

func _physics_process(delta: float) -> void:
	Signals.emit_signal("double_jump_enabled", double_jump)
	#print("Dash energy: ", dash_energy)
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	dash_recharge()
	
	process_input(delta)

	move_and_slide()


func process_input(delta: float) -> void:
	
	if Input.is_action_just_pressed("Menu"):
		queue_free()
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/main_menu.tscn")
	
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			double_jump = true
			velocity.y = jump_velocity
		if !is_on_floor() and double_jump:
			velocity.y = jump_velocity
			double_jump = false
	
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, spring_arm.rotation.y)
	
	if direction and Input.is_action_pressed("Dash") and dash_enabled:
		speed = 11.0
		jump_velocity = 11.0
		dash_energy -= 1
	else:
		speed = 5.0
		jump_velocity = 5.0
		
	if direction:
		velocity.x = direction.x * speed

	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
func new_item_collected(type: String) -> void:
	if type == "jump_fuel":
		double_jump = true
		if dash_energy < 90.0:
			dash_energy += 10.0
		
		if dash_energy > 90.0:
			dash_energy = 100.0


func dash_recharge() -> void:
	Signals.emit_signal("dash_energy_level", dash_energy)
	if dash_energy <= 0:
		dash_enabled = false
	
	if not dash_enabled:
		dash_energy += 0.1
		if dash_energy >= dash_energy_max:
			dash_energy = clampf(dash_energy, 0, dash_energy_max)
			dash_enabled = true
