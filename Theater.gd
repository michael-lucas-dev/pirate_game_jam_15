extends Node3D

@export var _viewport : Viewport
var is_open : bool = false

func _ready():
	var mat : StandardMaterial3D = StandardMaterial3D.new()
	mat.albedo_texture = _viewport.get_texture()
	$Screen.set_surface_override_material(0, mat)
	
func _process(delta):
	if !is_open:
		$main_curtain.position.x += 0.7 * delta
		if $main_curtain.position.x >= 50:
			is_open = true
