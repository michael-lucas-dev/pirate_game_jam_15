extends InteractableObject

@onready var test = get_node("../Game/GameFlat/Player")

func _interact():
	test.jump()
pass
