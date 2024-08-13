class_name Session
extends PanelContainer

signal loaded(index)

var conversation: Array = []

func _ready() -> void:
	$Label.text = name


func save_conv():
	var file = FileAccess.open("user://sessions/" + name + ".json", FileAccess.WRITE)
	file.store_string(JSON.stringify(conversation))

func load_conv() -> Array:
	if !FileAccess.file_exists(("user://sessions/" + name).get_base_dir()):
		save_conv()
	var file = FileAccess.open("user://sessions/" + name + ".json", FileAccess.READ)

	var data = JSON.parse_string(file.get_as_text())
	return data

func append(data: Dictionary):
	conversation = load_conv() + [data]


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_mask == MOUSE_BUTTON_LEFT:
			loaded.emit(get_index())
