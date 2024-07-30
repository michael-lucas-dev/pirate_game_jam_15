extends InteractableObject

@export var element : Element
@onready var test = get_node("../Game/GameFlat/Player")

func _interact():
	test.attack
pass
