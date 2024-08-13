class_name Session
extends PanelContainer

signal loaded(index)

@onready var right_click_menu: PopupMenu = $RightClickMenu

var conversation: Array = []

func _ready() -> void:
	DirAccess.make_dir_absolute("user://sessions")
	$Label.text = name

func change_border(colour: Color):
	var new_panel = get_theme_stylebox("panel").duplicate()
	new_panel.border_color = colour
	new_panel.border_color.a = 0.302
	add_theme_stylebox_override("panel", new_panel)


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
		if event.pressed:
			if event.button_mask == MOUSE_BUTTON_LEFT:
				loaded.emit(get_index())
			if event.button_mask == MOUSE_BUTTON_RIGHT:
				right_click_menu.position = event.global_position - Vector2(10, 10)
				right_click_menu.show()


func _on_right_click_menu_mouse_exited() -> void:
	right_click_menu.hide()


func _on_right_click_menu_index_pressed(index: int) -> void:
	match index:
		0:
			$PopupPanel.show()
			$PopupPanel/LineEdit.text = name
		1:
			DirAccess.remove_absolute("user://sessions/" + name + ".json")
			queue_free()


func _on_line_edit_text_submitted(new_text: String) -> void:
	DirAccess.remove_absolute("user://sessions/" + name + ".json")
	if new_text.is_empty():
		return
	name = new_text
	$PopupPanel.hide()
	$Label.text = new_text
	save_conv()
