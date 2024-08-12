class_name MDtoBB
extends Node

func md_to_bb(markdown_text: String) -> String:

	var bb_string = markdown_text

	bb_string = bold(bb_string)

	return bb_string

func bold(markdown_bold_text: String) -> String:

	var bb_bold_string = markdown_bold_text

	for bold in bb_bold_string.count("**") / 2:
		var start = bb_bold_string.findn("**")
		var end = bb_bold_string.findn("**", start + 1)
		bb_bold_string = bb_bold_string.erase(start, 2)
		bb_bold_string = bb_bold_string.insert(start, "[b]")
		bb_bold_string = bb_bold_string.erase(end + 1, 2)
		bb_bold_string = bb_bold_string.insert(end + 1, "[/b]")
		print(start, " : ", end)
	return bb_bold_string
