extends Control

@onready var request: HTTPRequest = $HTTPRequest

@export var secrets: Secrets
var model = "gemini-pro"


func _ready() -> void:
	ask("Hello")


func ask(prompt: String) -> String :
	var url = \
			"https://generativelanguage.googleapis.com/v1beta/models/" \
			+ model + ":generateContent?key=" + secrets.api_key

	var body = {
		"contents": [{
			"role": "user",

			"parts": [{
				"text": prompt,
			}],
		}],
	}

	#var headers = PackedStringArray(["contents: [{'role': 'user', 'parts': [{'text': " + prompt + "}]}]"])

	request.request(url, [{"Content-Type": "application/json"}], HTTPClient.METHOD_GET, str(body))
	request.request_completed.connect(_on_http_request_request_completed)

	return ""


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	print("Result: ", result)
	print("Code: ", response_code)
	print("Headers: ", headers)
	#var data = body.decode_var(0)
	#print("Data: ", data)
	print("Body: ", body)
	FileAccess.open("save.html", FileAccess.WRITE).store_buffer(body)
