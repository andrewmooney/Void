extends Node3D

var type: String = "jump_fuel"
@export var animation_player: AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("CollectableRotate")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	Signals.emit_signal("item_collected", type)
	print("item_collected", type)
	queue_free()
