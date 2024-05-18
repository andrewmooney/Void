extends Node

signal platform_destroyed(body: CharacterBody3D)
signal player_destroyed(body: RigidBody3D)
signal item_collected(type: String)
signal dash_energy_level(dash_energy: float)
signal double_jump_enabled(double_jump: bool)

