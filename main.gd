extends Control

@onready var request: HTTPRequest = $HTTPRequest

var model = "gemini-pro"
@export var api_key = ""

func _ready() -> void:
	ask("Hello")


func ask(prompt: String) -> String :
	var url = \
			"https://generativelanguage.googleapis.com/v1beta/models/" \
			+ model + ":generateContent?key=" + api_key

	#var body = {
		#"contents": [{
			#"role": "user",
#
			#"parts": [{
				#"text": prompt,
			#}],
		#}],
	#}

	var headers = PackedStringArray(["contents: [{'role': 'user', 'parts': [{'text': " + prompt + "}]}]"])

	request.request(url, headers)
	request.request_completed.connect(_on_http_request_request_completed)

	return ""


func _on_http_request_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	print("SMTH")
	print(response_code)
