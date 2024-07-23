extends Node

@export var obstacle : PackedScene

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
	var random : int = randi() % 2
	var obstacle_instance : Area2D = obstacle.instantiate()
	add_child(obstacle_instance)
	obstacle_instance.body_entered.connect(_hit_obstacle.bind(obstacle_instance))
	obstacle_instance.position.x = spawned_object_position_x
	
	if random:
		obstacle_instance.position.y = 800
		obstacle_instance.scale.y *= -1
	else:
		obstacle_instance.position.y = 200
		
func _hit_obstacle(body: Node2D, obstacle_instance: Area2D):
	if body.is_in_group("Player"):
		health -= 10
		obstacle_instance.queue_free()
		

