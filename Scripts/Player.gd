class_name Player
extends CharacterBody3D

const dash_energy_max: float = 100.0
var jump_velocity: float = 5.0

@export var debug: bool = false

var speed: float = 5.0

var dash_energy: float = 100.0
var dash_enabled: bool = true
var dash_energy_increment: float = 0.2
var double_jump: bool = true

@onready var spring_arm: SpringArm3D = $SpringArm3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
	#print("Dash energy: ", dash_energy)
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	dash_recharge()
	
	process_input(delta)
	
	if debug:
		test_input()

	move_and_slide()

func process_input(delta: float) -> void:
	# Handle jump.
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			double_jump = true
			velocity.y = jump_velocity
		if !is_on_floor() and double_jump:
			velocity.y = jump_velocity
			double_jump = false
	
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backwards")
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
		#velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		#velocity.z = move_toward(velocity.z, 0, speed)
	
#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseMotion:
		#spring_arm.rotation.x += event.relative.y * -0.005
		#spring_arm.rotation.y -= event.relative.x * 0.005

func dash_recharge() -> void:
	if dash_energy <= 0:
		dash_enabled = false
	
	if not dash_enabled:
		dash_energy += 0.1
		if dash_energy >= dash_energy_max:
			dash_energy = clampf(dash_energy, 0, dash_energy_max)
			dash_enabled = true
			
func test_input():
	if Input.is_action_just_pressed("Test"):
		get_node("CollisionShape3D").disabled = true
