extends Marker3D

@export var rotation_per_second: float = 0.5            # Complete turns per second
@export var rotation_axis: Vector3 = Vector3.UP         # Axis to spin around (local space)

func _ready() -> void:
	# Ensure the axis is a unit-vector so speed is consistent
	rotation_axis = rotation_axis.normalized()

func _process(delta: float) -> void:
	# Rotate this node around the chosen axis.
	# TAU = 2π.  (rotation_per_second * TAU) gives radians/second.
	rotate_object_local(rotation_axis, rotation_per_second * TAU * delta)
