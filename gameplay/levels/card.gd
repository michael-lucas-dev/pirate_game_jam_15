extends MeshInstance3D

@export var color : Color

# Called when the node enters the scene tree for the first time.
func _ready():
	var material : StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = color
	set_surface_override_material(0, material)
	pass # Replace with function body.
