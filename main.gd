extends Control

@onready var request: HTTPRequest = $HTTPRequest
@export var secrets: Secrets
var model = "gemini-1.5-flash"

var response_text

func _ready() -> void:
	await ask("Hello")
	print(response_text)


func ask(prompt: String) -> void:
	var url = \
			"https://generativelanguage.googleapis.com/v1beta/models/" \
			+ model + ":generateContent?key=" + secrets.api_key

	var content = {
		"contents": [{
			"role": "user",

			"parts": [{
				"text": prompt,
			}],

		}],
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

	#var response_text := ""

	request.request_completed.connect(
			func(_r, _r_code, _h, body: PackedByteArray):
				var data = JSON.parse_string(body.get_string_from_utf8())
				response_text = data["candidates"][0]["content"]["parts"][0]["text"])

	request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(content))

	await request.request_completed

	#return response_text





