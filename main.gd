extends Control

@onready var request: HTTPRequest = $HTTPRequest
@export var secrets: Secrets
@export var message: PackedScene
var model = "gemini-1.5-flash"

var response_text:
	set(value):
		response_text = value
		add_message(true, value)

var conversation: Array[Dictionary]

func _ready() -> void:

	conversation = []

func add_message(bot: bool, message_text: String):
	var new_message: Control = message.instantiate()
	new_message.bot = bot
	%Messages.add_child(new_message)

	new_message.label.text = message_text

	scroll_down()

func scroll_down():
	await get_tree().process_frame
	await get_tree().process_frame
	%ScrollContainer.scroll_vertical = \
			%ScrollContainer.get_v_scroll_bar().max_value

func ask(prompt: String) -> void:
	var url = \
			"https://generativelanguage.googleapis.com/v1beta/models/" \
			+ model + ":generateContent?key=" + secrets.api_key

	conversation.append({
			"role": "user",

			"parts": [{
				"text": prompt,
			}]}
		)


	var content = {
		"contents": conversation,

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

	conversation.append({
			"role": "model",

			"parts": [{
				"text": response_text,
			}]}
		)





func _on_http_request_request_completed(_r, _r_code, _h, body: PackedByteArray) -> void:
		var data = JSON.parse_string(body.get_string_from_utf8())
		FileAccess.open("save.json", FileAccess.WRITE).store_buffer(body)
		response_text = data["candidates"][0]["content"]["parts"][0]["text"]


func _on_line_edit_text_submitted(new_text):
	$MainBody/LineEdit.text = ""
	add_message(false, new_text)

	await ask(new_text)

