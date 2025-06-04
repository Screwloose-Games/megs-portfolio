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
	# 1) Add each bus in order, capturing name→index for later "send" lookups.
	var original_layout: AudioBusLayout = AudioServer.generate_bus_layout()
	var layout: AudioBusLayout = AudioBusLayout.new()
	layout.resource_path = EXPORT_PATH
	AudioServer.set_bus_layout(layout)
	
	var name_to_index := {}
	for i in range(bus_config["buses"].size()):
		var bus_dict: Dictionary = bus_config["buses"][i]
		if bus_dict.name == "Master":
			continue
		AudioServer.add_bus(i)
		AudioServer.set_bus_name(i, bus_dict["name"])
		AudioServer.set_bus_volume_db(i, bus_dict["volume_db"])
		AudioServer.set_bus_mute(i, bus_dict["mute"])
		AudioServer.set_bus_solo(i, bus_dict["solo"])
		AudioServer.set_bus_bypass_effects(i, bus_dict["bypass_fx"])
		name_to_index[bus_dict["name"]] = i

	# 2) Second pass: assign "send" indices now that all buses exist.
	for i in range(bus_config["buses"].size()):
		var bus_dict: Dictionary = bus_config["buses"][i]
		if bus_dict.has("send") and bus_dict["send"] != null:
			var target_name: String = bus_dict["send"]
			if name_to_index.has(target_name):
				AudioServer.set_bus_send(i, name_to_index[target_name])

	for i in range(bus_config["buses"].size()):
		var bus_dict: Dictionary = bus_config["buses"][i]
		var send_index := -1
		if bus_dict.has("send") and bus_dict["send"] != null and name_to_index.has(bus_dict["send"]):
			send_index = name_to_index[bus_dict["send"]]

	var new_layout = AudioServer.generate_bus_layout()
	var err := ResourceSaver.save(new_layout, EXPORT_PATH, ResourceSaver.FLAG_CHANGE_PATH)
	if err == OK:
		printerr("✅ Saved (and overwrote) AudioBusLayout to '%s'." % EXPORT_PATH)
	else:
		printerr("❌ Failed to save AudioBusLayout (%d) to '%s'." % [err, EXPORT_PATH])
	
	# reload previous layout:

	AudioServer.set_bus_layout(original_layout)
	
	
