class_name MDtoBB
extends Node

func md_to_bb(markdown_text: String) -> String:

	var bb_string = markdown_text

	#var code_text

	bb_string = code(bb_string)
	bb_string = bold(bb_string)
	bb_string = italic(bb_string)
	bb_string = heading(bb_string)

	return bb_string

func code(markdown_code_text: String) -> String:

	var bb_string = markdown_code_text

	for i in ceil(bb_string.count("`") / 2.0):

		var start = bb_string.findn("`")
		bb_string = bb_string.erase(start, 1)
		bb_string = bb_string.insert(start, "[code]")

		var end = bb_string.findn("`", start + 1)
		bb_string = bb_string.erase(end, 1)
		bb_string = bb_string.insert(end, "[/code]")

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

func heading(markdown_heading_text: String) -> String:

	var bb_string := markdown_heading_text

	if bb_string.begins_with("# "):
		bb_string = bb_string.erase(0, 2)
		bb_string = bb_string.insert(0, "[font_size=30]")
		bb_string = bb_string.insert(bb_string.find("\n", 1), "[/font_size]")

	return bb_string
