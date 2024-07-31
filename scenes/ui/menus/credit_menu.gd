extends Control

signal back_button

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_main_menu_button_pressed():
	back_button.emit()
	get_tree().change_scene_to_file("res://scenes/ui/menus/main_menu.tscn")
