class_name Session
extends PanelContainer

var file: FileAccess

func _ready() -> void:
	DirAccess.make_dir_absolute("user://sessions")
	pass
	#file = FileAccess.open("user://sessions/" + name, )

func save_conv(conversation: Array[Dictionary]):
	file = FileAccess.open("user://sessions/" + name + ".json", FileAccess.WRITE)
	file.store_string(JSON.stringify(conversation))

func load_conv() -> Array[Dictionary]:
	if !FileAccess.file_exists(("user://sessions/" + name).get_base_dir()):
		save_conv([])
	file = FileAccess.open("user://sessions/" + name + ".json", FileAccess.READ)
	var json = JSON.new().parse(file.to_string())
	var data: Array[Dictionary]
	print(json)
	return data

func append(data: Dictionary):
	save_conv(load_conv() + [data])
