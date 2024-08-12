extends Control


var model = ""
var api_key = ""

func ask(prompt: String) -> String :
	var url = \
			"https://generativelanguage.googleapis.com/v1beta/models/" \
			+ model + ":generateContent?key=" + api_key

	var body = {
		"contents": [{
			"role": "user",

			"parts": [{
				"text": prompt,
			}],
		}],
	}

	return ""
