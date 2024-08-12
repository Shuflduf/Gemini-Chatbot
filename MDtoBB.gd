class_name MDtoBB
extends Node

func md_to_bb(markdown_text: String) -> String:

	var bb_string = markdown_text

	bb_string = bold(bb_string)
	bb_string = italic(bb_string)
	bb_string = heading(bb_string)

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

	if bb_string.get_slice_count("# ") <= 0:
		return bb_string

	if bb_string.begins_with("# "):
		bb_string = bb_string.erase(0, 2)
		bb_string = bb_string.insert(0, "[font_size=40]")
		bb_string = bb_string.insert(bb_string.find("\n", 1), "[/font_size]")

		#index = 0

	#for i in bb_string.get_slice_count("# "):
		#var index = bb_string.find("\n# ")
		#
		#var end_index = bb_string.find("\n", index + 1)
		#bb_string = bb_string.erase(index, 2)
		#bb_string = bb_string.insert(index, "[font_size=40]")
		#bb_string = bb_string.insert(end_index, "[/font_size]")
		##bb_string += "[/font_size]"
		#print(index, " : ", end_index)

	return bb_string
