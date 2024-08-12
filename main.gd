extends Control

@onready var request: HTTPRequest = $HTTPRequest
@export var secrets: Secrets
var model = "gemini-1.5-flash"

var response_text:
	set(value):
		response_text = value
		$Label.text = value

var conversation: Array[Dictionary]

func _ready() -> void:

	conversation = []




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

	#print(conversation)


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

	#FileAccess.open("save.json", FileAccess.WRITE).store_string(str(conversation))



func _on_http_request_request_completed(_r, _r_code, _h, body: PackedByteArray) -> void:
		var data = JSON.parse_string(body.get_string_from_utf8())
		response_text = data["candidates"][0]["content"]["parts"][0]["text"]


func _on_line_edit_text_submitted(new_text):
	await ask(new_text)
