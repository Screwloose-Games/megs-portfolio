class_name Player
extends CharacterBody3D

@export var allow_player_input: bool = true
@export var cutscene_mode_enabled: bool = false
@export var rotation_duration: float = 0.2
@export var speed = 5.0
@export var JUMP_VELOCITY = 4.5

@onready var model: Node3D = %Model
@onready var directional_movement: DirectionalMovement = %DirectionalMovement

func _ready() -> void:
	pass

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func get_horizontal_velocity(delta: float) -> Vector3:
	if should_ignore_input:
		return Vector3.ZERO
	return directional_movement.get_velocity(delta, speed)


func _physics_process(delta: float) -> void:
	if not allow_player_input:
		return
	
	velocity = get_horizontal_velocity(delta)
	
	if player_mode == PlayerMode.BUILD:
		handle_build_mode()
	
	if not is_on_floor():
		var gravity = get_gravity()
		velocity += gravity

	var horizontal_velocity = Vector3(velocity.x, 0, velocity.z)
	
	if horizontal_velocity.length_squared() > 0.01:
		state = SelfState.WALK
		var direction = horizontal_velocity.normalized()
		var target_basis = Basis.looking_at(-direction, Vector3.UP)
		model.basis = model.basis.slerp(target_basis, 1.0 / rotation_duration * delta)

	else:
		state = SelfState.IDLE
	
	move_and_slide()
