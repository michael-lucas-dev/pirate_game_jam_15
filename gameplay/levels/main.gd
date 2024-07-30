extends Node3D
class_name World


#Step 1
var target_rotation_1 = Vector3(0.075, 1.016, 0)

#Step 2
var target_rotation_2 = Vector3(-0.01, -0.868011, 0)

var target_position = Vector3(-0.027, 0, 3.409)

var smooth_rotation: Vector3
var timer_counter = 0

static var _instance: World = null
@onready var game = get_node("GameView/GameFlat")
@onready var camera = $Player3D/Camera3D

enum Element {AIR, WATER, FIRE, EARTH}
var death_step : int = 0

func _ready():
	game.health_depleted.connect(_death)
	get_tree().paused = false
	_instance = self if _instance == null else _instance
	

func _death():
	if death_step == 0:
		print("death!")
		$Player3D.is_input_reading = false
		death_step = 1
	
func _process(delta):
	print(camera.global_rotation)
	if death_step == 1:
		$Player3D.position = target_position
		smooth_rotation = smooth_rotation.lerp(target_rotation_1, delta * 10)
		camera.global_rotation = smooth_rotation 
	if death_step == 1 && camera.global_rotation.is_equal_approx(target_rotation_1):
			$godzilla.visible = true
			death_step = 2
	if death_step == 2:
		smooth_rotation = smooth_rotation.lerp(target_rotation_2, delta * 2)
		camera.global_rotation = smooth_rotation 
	if death_step == 2 && camera.global_rotation.is_equal_approx(target_rotation_2):
			death_step = 3
	if death_step == 3:
		smooth_rotation = smooth_rotation.lerp(target_rotation_2, delta * 2)
		camera.global_rotation = smooth_rotation 

func _on_timer_timeout():
	timer_counter += 1
	if $VoiceMusicPlayer.playing == false:
		$VoiceMusicPlayer.play(
