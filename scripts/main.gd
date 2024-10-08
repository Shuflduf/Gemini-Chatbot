extends Control

@onready var sessions: VBoxContainer = %Sessions
@onready var messages: VBoxContainer = %Messages
@onready var md_bb: MDtoBB = $MDtoBB
@onready var request: HTTPRequest = $HTTPRequest

@export var secrets: Secrets
@export var message: PackedScene
@export var session_scene: PackedScene
var model = "gemini-1.5-flash"

var response_text:
	set(value):
		response_text = value
		add_message(true, value)

var session: Session

func _ready() -> void:
	if FileAccess.file_exists("user://key"):
		secrets.api_key = FileAccess.open("user://key", FileAccess.READ).get_as_text()

	if FileAccess.file_exists("user://colour.txt"):
		var col_str = FileAccess.open("user://colour.txt", FileAccess.READ).get_as_text()
		col_str = col_str.lstrip("(").rstrip(")")
		var col_arr = col_str.split(", ")
		print(col_arr)
		var new_col = Color(\
				float(col_arr[0]), \
				float(col_arr[1]), \
				float(col_arr[2]), 1.0
			)
		$"../Colour".modulate = new_col
		$Info/VBoxContainer/HBoxContainer2/ColorPickerButton.color = new_col

	if secrets.api_key.is_empty():
		$ApiKeyPopup.show()
	add_sessions()


func _on_api_line_edit_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		return

	secrets = Secrets.new()
	secrets.api_key = new_text
	FileAccess.open("user://key", FileAccess.WRITE).store_string(new_text)
	$ApiKeyPopup.hide()

func _on_settings_line_edit_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		return

	secrets = Secrets.new()
	secrets.api_key = new_text
	FileAccess.open("user://key", FileAccess.WRITE).store_string(new_text)
	$Info.hide()

func add_sessions() -> void:
	for i in sessions.get_children():
		i.free()

	for i in DirAccess.get_files_at("user://sessions/"):
		var new_session = session_scene.instantiate()
		new_session.name = i.trim_suffix(".json")
		new_session.conversation = \
				JSON.parse_string(\
				FileAccess.open("user://sessions/" + i, FileAccess.READ)\
				.get_as_text())
		sessions.add_child(new_session)

	connect_sessions()

func connect_sessions():
	for i in sessions.get_child_count():
		var c = sessions.get_child(i)

		if !c.get_signal_connection_list("tree_exited"):
			c.tree_exited.connect(func():
				for m in messages.get_children():
					m.queue_free()

				connect_sessions())

		if c.get_signal_connection_list("loaded"):
			c.disconnect("loaded", _connect_single_session)
		c.loaded.connect(_connect_single_session)


func select_session(index: int):
	for i in sessions.get_children():
		i.change_border(Color.BLACK)

	sessions.get_child(index).change_border(Color.WHITE)

func _connect_single_session(index: int):
	select_session(index)
	session = sessions.get_child(index)
	replace_all_messages(index)

func replace_all_messages(index):
	for i in messages.get_children():
		i.free()

	for i in sessions.get_child(index).conversation:
		var bot = true if i["role"] == "model" else false
		add_message(bot, i["parts"][0]["text"])


func add_message(bot: bool, message_text: String):
	var new_message: Control = message.instantiate()
	new_message.bot = bot
	messages.add_child(new_message)

	new_message.label.text = md_bb.md_to_bb(message_text)

	scroll_down()

func scroll_down():
	await get_tree().process_frame
	await get_tree().process_frame
	%ScrollContainer.scroll_vertical = \
			%ScrollContainer.get_v_scroll_bar().max_value

func ask(prompt: String) -> void:

	if session == null:
		session = session_scene.instantiate()
		sessions.add_child(session, true)
		connect_sessions()


	var url = \
			"https://generativelanguage.googleapis.com/v1beta/models/" \
			+ model + ":generateContent?key=" + secrets.api_key

	session.append({
			"role": "user",

			"parts": [{
				"text": prompt,
			}]}
		)


	var content = {
		"contents": session.load_conv(),

		"safety_settings": [
			{
			  "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
			  "threshold": "BLOCK_NONE"
			},

			{
			  "category": "HARM_CATEGORY_HATE_SPEECH",
			  "threshold": "BLOCK_NONE"
			},

			{
			  "category": "HARM_CATEGORY_HARASSMENT",
			  "threshold": "BLOCK_NONE"
			},

			{
			  "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
			  "threshold": "BLOCK_NONE"
			}
		  ]
		}

	var headers = ["Content-Type: application/json"]

	request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(content))

	await request.request_completed

	session.conversation = session.load_conv() + [{
		"role": "model",

		"parts": [{
			"text": response_text,
		}]}]

	session.save_conv()


func _on_http_request_request_completed(_r, _r_code, _h, body: PackedByteArray) -> void:
	var data: Dictionary = JSON.parse_string(body.get_string_from_utf8())
	#FileAccess.open("save.json", FileAccess.WRITE).store_buffer(body)

	if data.has("error"):
		response_text = \
				"Error " + str(data["error"]["code"]) + ": " + data["error"]["message"]
		if data["error"]["code"] == 400:
			%APILineEdit.text = ""
			$ApiKeyPopup.show()
	else:
		response_text = data["candidates"][0]["content"]["parts"][0]["text"]


func _on_line_edit_text_submitted(new_text: String):
	%LineEdit.text = ""

	if secrets.api_key.is_empty():
		$ApiKeyPopup.show()
		return


	if new_text.is_empty():
		return

	add_message(false, new_text + "\n")

	sessions.move_child(session, 0)

	await ask(new_text)


func _on_new_session_pressed() -> void:
	session = session_scene.instantiate()
	sessions.add_child(session, true)
	sessions.move_child(session, 0)
	select_session(0)
	connect_sessions()
	replace_all_messages(0)


func _on_open_settings_pressed() -> void:
	$Info/VBoxContainer/HBoxContainer/SettingsLineEdit.text = ""
	$Info.show()


func _on_info_close_requested() -> void:
	$Info.hide()


func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))


func _on_color_picker_button_color_changed(color: Color) -> void:
	FileAccess.open("user://colour.txt", FileAccess.WRITE).store_string(str(color))
	$"../Colour".modulate = color
