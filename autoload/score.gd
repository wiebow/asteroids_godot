# score.gd

extends Node

# Autoload script, also requirement for the gameover scene.
# This scipt handles score, hiscore, and load/save

# file name for the hiscore list.
# Where this is saved depends on the system.
# The gamename is the name entered in the project settings.
#
# Linux: .local/share/godot/app_userdata/<gamename>/game-data.json
# Windows:
# Mac:
const FILE_NAME: String = "user://game-data.json"

# The default hiscore list.
# The 11th item is not printed , but used as the
# place of entry for a new item.
var score_list: Array = [
	[12060, "wdw"], [12000, "tim"], [11000, "cis"],
	[10000, "mrc"], [9000, "amg"], [8000, "dee"],
	[7000, "s-i"], [6000, "mvg"], [5000, "myy"],
	[4000, "gwd"], [0, ""]
]


# Called when the game starts, as this is an autoload script.
func _ready() -> void:
	load_scores()


func save_scores() -> void:
	var save_dict = {}
	var index: int = 0
	while index < 10:
		var entry: Array = score_list[index]
		# save score and name to dict
		save_dict[entry[0]] = entry[1]
		index += 1

	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_string(to_json(save_dict))
	file.close()


func load_scores() -> void:
	var file: File = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:

			# lets convert the loaded dict to the array that we need
			score_list.clear()
			var keyValuePair :Array = []
			for key in data:
				#convert score to int, and use string for name
				keyValuePair = [int(key), data[key]]
				score_list.append(keyValuePair)

			# add dummy item as item 10
			keyValuePair = [0,""]
			score_list.append( keyValuePair )

			_sort_list()
		else:
			printerr("Corrupted hiscore data!")
	else:
		printerr("No saved hiscore data!")


# Returns the value of the lowest score
func get_lowest_score() -> int:
	var entry = score_list[9]
	return entry[0]


# Returns the hiscore value as an int.
func get_hi_score() -> int:
	var entry = score_list[0]
	return entry[0]


# Returns the score table as an array.
func get_score_entries() -> Array:
	return score_list


# A new score with no name is added to the bottom of the table.
func add_score_to_list(new_score: int) -> Array:

	# New item for the list, with empty name.
	# The name is entered in the hiscore scene.
	var new_item: Array = [new_score, "   "]
	
	_sort_list()
	# new score is always added in index 10
	score_list[10] = new_item
	_sort_list()

	# Return the new item to the calling function
	# for us this is the gameover scene.
	return new_item


func _sort_list() -> void:
	score_list.sort_custom(MyCustomSorter, "sort_descending")


# Internal class for sorting the score list.
# Stolen from the godot docs.
class MyCustomSorter:
	static func sort_ascending(a, b):
		if a[0] < b[0]:
			return true
		return false

	static func sort_descending(a, b):
		if a[0] > b[0]:
			return true
		return false
