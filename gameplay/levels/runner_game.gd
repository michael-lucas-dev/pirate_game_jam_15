extends Node

signal health_depleted

var enemy_list = [
	preload("res://gameplay/monsters/firel.tscn"),
	preload("res://gameplay/monsters/leaupez.tscn"),
	preload("res://gameplay/monsters/pivent.tscn"),
	preload("res://gameplay/monsters/slime.tscn")
]
@onready var player = get_node("Player")

@onready var bullet_scene: PackedScene = preload("res://gameplay/player/bullet.tscn")

var dynamic_objects_speed: int = 100
var health : float = 5
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
		
func _hit_enemy(body: Node2D, enemy_instance: Monster):
	print(body.get_groups())
	if body.is_in_group("Player"):
		health -= 1
		health_depleted.emit()
		enemy_instance.queue_free()
		
		
	elif body.is_in_group("Bullet"):
		enemy_instance.queue_free()
		body.queue_free()
		
func attack(element):
	var bullet_temp = bullet_scene.instantiate()
	bullet_temp.element = element
	bullet_temp.bullet_owner = "Player"
	bullet_temp.position = player.global_position
	bullet_temp.direction = Vector2(1,0)
	get_node("bullets").add_child(bullet_temp)
	

