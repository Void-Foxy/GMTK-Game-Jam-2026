extends Node

var load_cache: Dictionary[String, LoadCache] = {}

func load_scenes(path: String, excluded_patterns: Array[String] = []) -> Dictionary[String, Resource]:
	return _load_resources_with_extension(path, ".tscn", excluded_patterns)

func load_scripts(path: String, excluded_patterns: Array[String] = []) -> Dictionary[String, Resource]:
	return _load_resources_with_extension(path, ".gd", excluded_patterns)


func _load_resources_with_extension(
	path: String,
	file_extension: String,
	excluded_patterns: Array[String] = []
) -> Dictionary[String, Resource]:
	path = path.trim_suffix("/")
	var cache_key := "%s|%s" % [path, file_extension]
	
	if load_cache.has(cache_key):
		return load_cache[cache_key].loaded_resources
	
	var loaded_resources: Dictionary[String, Resource] = {}
	var dir: DirAccess = DirAccess.open(path)
	_navigate_directory(dir, path, loaded_resources, excluded_patterns, file_extension)
	load_cache[cache_key] = LoadCache.new(loaded_resources)
	return loaded_resources

func _navigate_directory(
	dir: DirAccess, 
	current_path: String, 
	loaded_resources: Dictionary[String, Resource],
	excluded_patterns: Array[String] = [],
	file_extension: String = ".tscn"
) -> void:
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			var new_path := current_path.path_join(file_name)
			_navigate_directory(DirAccess.open(new_path), new_path, loaded_resources, [], file_extension)
		elif file_name.ends_with(file_extension):
			var excluded_scene := false
			for pattern in excluded_patterns:
				var regex := RegEx.new()
				regex.compile(pattern)
				if regex.search(file_name.replace(file_extension, "")):
					excluded_scene = true
					break
			if !excluded_scene:
				loaded_resources[file_name.replace(file_extension, "").to_pascal_case()] = load(current_path.path_join(file_name))
		file_name = dir.get_next()
	dir.list_dir_end()

class LoadCache:
	extends Resource
	
	var loaded_resources: Dictionary[String, Resource]
	func _init(_loaded_resources: Dictionary[String, Resource]) -> void:
		loaded_resources = _loaded_resources
	
