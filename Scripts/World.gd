extends Node3D

@export_category("Platform")
@export var platforms: Array[PackedScene]
@export var initial_number_platforms: int = 5
@export var offset: int = 5
@export var x_range: Vector2i = Vector2i(-20, 20)
@export var bounds: Dictionary = {"neg": -50, "pos": 50}

@export_category("Vortex")
@export var vortex_scene: PackedScene
@export var vortex_position: Vector3 = Vector3(0.0, 0.0, 0.0)
@export var vortex_speed: float = 1

var vortex: Vortex
var max_jump: int = 25
var next_platform_position: Vector3 = Vector3(0, 5, 0)
var previous_platform_position: Vector3
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var level: int = 1
var platforms_destroyed: int = 0;

func _ready() -> void:
	
	Signals.connect("platform_destroyed", remove_platform)
	Signals.connect("player_destroyed", remove_player)
	
	# Instantiate Vortex
	vortex = vortex_scene.instantiate()
	add_child(vortex)
	vortex.position = vortex_position
	vortex.scale = Vector3(10, 10, 10)
	
	# Spawn initial platforms
	for n in initial_number_platforms:
		spawn_platform()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	vortex.position.y += (vortex_speed + level / 2) * delta
	if Input.is_action_just_pressed("Restart"):
		get_tree().reload_current_scene()
	
	if get_tree().paused and Input.is_action_just_pressed("Jump"):
		get_tree().paused = false
		

func set_next_position() -> void:
	var random_x_pos = func ():
		var random_pos_neg = func():
			if rng.randf_range(0, 1) < 0.5: 
				return -1 
			return 1
			
		var next_x = previous_platform_position.x + rng.randi_range(5, 8) * random_pos_neg.call()
		
		var jump_distance = next_x + previous_platform_position.x
		
		while jump_distance > max_jump or jump_distance < max_jump * -1:
			next_x = previous_platform_position.x + rng.randi_range(5, 8) * random_pos_neg.call()
			jump_distance = next_x + previous_platform_position.x
		print(jump_distance)
		return next_x
		
	rng.randomize()
	previous_platform_position = Vector3(next_platform_position)
	next_platform_position.y = previous_platform_position.y + offset
	next_platform_position.x = random_x_pos.call()
	print("Spawning new platform at: ", next_platform_position)

func remove_player(body) -> void:
	#body.free()
	get_tree().reload_current_scene()     

func remove_platform(body) -> void:
	body.free()
	platforms_destroyed += 1
	if platforms_destroyed / level > 20:
		level += 1
		
	spawn_platform()

func spawn_platform() -> void:
	rng.randomize()
	var index = rng.randi_range(0, platforms.size() -1)
	var platform = platforms[index].instantiate()
	platform.position = next_platform_position

	add_child(platform)
	set_next_position()
