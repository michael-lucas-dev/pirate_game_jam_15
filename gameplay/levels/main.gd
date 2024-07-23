extends Node3D
class_name World

static var _instance: World = null

enum Element {AIR, WATER, FIRE, EARTH}

func _ready():
	get_tree().paused = false
	_instance = self if _instance == null else _instance

