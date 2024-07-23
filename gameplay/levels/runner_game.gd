extends Node

var enemy_list = [
	preload("res://gameplay/monsters/firel.tscn"),
	preload("res://gameplay/monsters/leaupez.tscn"),
	preload("res://gameplay/monsters/pivent.tscn"),
	preload("res://gameplay/monsters/slime.tscn")
]

var dynamic_objects_speed: int = 700
var health : float = 100
var score : float = 0

var spawned_object_position_x : int = 1700

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	score += delta
	$UI/HealthBar/ScoreLabel.text = str(snappedf(score,0.01))
	$UI/HealthBar.value = health
	for dynamic_object in get_tree().get_nodes_in_group("DynamicObject"):
		dynamic_object.position.x -= delta * dynamic_objects_speed
	pass


func _on_spawner_timer_timeout():
	var enemy_spawn = randf_range(0, enemy_list.size())
	var enemy = enemy_list[enemy_spawn].instantiate()
	enemy.position = Vector2(spawned_object_position_x, 800)
	enemy.body_entered.connect(_hit_enemy.bind(enemy))
	add_child(enemy)
		
func _hit_enemy(body: Node2D, enemy_instance: Area2D):
	if body.is_in_group("Player"):
		health -= 10
		enemy_instance.queue_free()
		

