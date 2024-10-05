class_name Utility

static func get_2d_array(width : int, height : int, fill = null) -> Array:
	var array = []
	for ci in range(height):
		var row = []
		row.resize(width)
		row.fill(fill)
		array.append(row)
	return array
