# Save this file somewhere under your project (e.g. res://editor/save_default_bus_layout.gd)
# Open it in the Script Editor and press “Run” to execute.
@tool
extends EditorScript

const EXPORT_PATH := "res://_default_bus_layout.tres"

@export var bus_config: Dictionary = {
  "buses": [
	{
	  "name": "Master",
	  "volume_db": 0.0,
	  "solo": false,
	  "mute": false,
	  "bypass_fx": false,
	  "send": null
	},
	{
	  "name": "Special",
	  "volume_db": 0.0,
	  "solo": false,
	  "mute": false,
	  "bypass_fx": false,
	  "send": "Master"
	},
	{
	  "name": "Musak",
	  "volume_db": 0.0,
	  "solo": false,
	  "mute": false,
	  "bypass_fx": false,
	  "send": "Master"
	},
	{
	  "name": "Ambidoo",
	  "volume_db": 0.0,
	  "solo": false,
	  "mute": false,
	  "bypass_fx": false,
	  "send": "Master"
	},
	{
	  "name": "Doogie",
	  "volume_db": 0.0,
	  "solo": false,
	  "mute": false,
	  "bypass_fx": false,
	  "send": "Master"
	}
  ]
}


func _run() -> void:
	var layout: AudioBusLayout = AudioBusLayout.new()
	AudioServer.set_bus_layout(layout)
	
	var next_bus_position = 0
	for audio_bus in bus_config.buses:
		if audio_bus.name == "Master":
			continue
		AudioServer.add_bus(next_bus_position)
		AudioServer.set_bus_name(next_bus_position, audio_bus.name)
		AudioServer.set_bus_mute(next_bus_position, audio_bus.mute)
		AudioServer.set_bus_solo(next_bus_position, audio_bus.solo)
		AudioServer.set_bus_send(next_bus_position, audio_bus.send)
	
	var err := ResourceSaver.save(layout, EXPORT_PATH)
	if err == OK:
		printerr("✅ Saved (and overwrote) AudioBusLayout to '%s'." % EXPORT_PATH)
	else:
		printerr("❌ Failed to save AudioBusLayout (%d) to '%s'." % [err, EXPORT_PATH])
