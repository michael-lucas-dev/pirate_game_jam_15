extends InteractableObject

enum ElementCard {NULL, AIR, WATER, FIRE, EARTH}
@export var element : ElementCard
@export var color : Color
@onready var game_flat = get_node("../GameView/GameFlat")
@onready var mesh = get_node("CardMesh")
@export var enabled : bool = false

signal on_interact_card

# Called when the node enters the scene tree for the first time.
func _ready():
	set_interact_prompt()
	if mesh != null:
		var material : StandardMaterial3D = StandardMaterial3D.new()
		material.albedo_color = color
		mesh.set_surface_override_material(0, material)
	pass # Replace with function body.

func set_interact_prompt():
	interact_prompt = "Enable" if !enabled else "Disable" 
	interact_prompt += " " + ElementCard.keys()[element] + " spell"
	

func disable():
	enabled = false
	$CardLight.visible = false
	set_interact_prompt()

func _interact():
	enabled = !enabled
	$CardLight.visible = enabled
	set_interact_prompt()
	on_interact_card.emit(element)
pass
