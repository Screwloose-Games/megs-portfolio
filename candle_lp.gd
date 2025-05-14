extends Node3D

@onready var omni_light_3d: OmniLight3D = %OmniLight3D

@export_range(0.0, 10.0, 0.1)
var flicker_intensity: float = 0.3

@export_range(0.0, 50.0, 0.1)
var flicker_speed: float = 10.0

@export_range(0.0, 10000.0, 0.1)
var base_energy: float = 500.0

var flicker_time: float = 0.0

func _process(delta: float) -> void:
	flicker_time += delta * flicker_speed
	var flicker_offset = sin(flicker_time * PI * 2.0) * randf_range(-1.0, 1.0) * flicker_intensity
	omni_light_3d.light_energy = base_energy + flicker_offset
