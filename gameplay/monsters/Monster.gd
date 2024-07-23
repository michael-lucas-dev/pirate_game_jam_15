class_name Monster
extends Area2D

enum Element {AIR, WATER, FIRE, EARTH}

@export var element : Element
@export var speed : float = 1
@export var health : float = 10

func _attack():
	print("To implement attack")
	
func _defend():
	print("To implement defense")
	
func _move():
	print("To implement move")
