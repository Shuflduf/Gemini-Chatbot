class_name MDtoBB
extends Node

func md_to_bb(markdown_text: String) -> String:

	var bb_string = markdown_text

	bb_string = bold(bb_string)
	bb_string = italic(bb_string)

	return bb_string

func bold(markdown_bold_text: String) -> String:

	var bb_string = markdown_bold_text


	for i in ceil(bb_string.count("**") / 2.0):
		var start = bb_string.findn("**")
		var end = bb_string.findn("**", start + 1)
		bb_string = bb_string.erase(start, 2)
		bb_string = bb_string.insert(start, "[b]")
		bb_string = bb_string.erase(end + 1, 2)
		bb_string = bb_string.insert(end + 1, "[/b]")

	return bb_string

func italic(markdown_italic_text: String) -> String:

	var bb_string = markdown_italic_text


	for i in ceil(bb_string.count("*") / 2.0):
		var start = bb_string.findn("*")
		var end = bb_string.findn("*", start + 1)
		bb_string = bb_string.erase(start, 1)
		bb_string = bb_string.insert(start, "[i]")
		bb_string = bb_string.erase(end + 2, 1)
		bb_string = bb_string.insert(end + 2, "[/i]")
	return bb_string
