extends Node3D
class_name World

@onready var card_list : Array[InteractableObject] = [
	$CardAir, $CardWater, $CardFire, $CardEarth
]

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

enum Element {NULL=0, AIR=1, WATER=2, FIRE=3, EARTH=4}
enum ElementAtt {NULL = 0, AIR = 1, WATER = 2, FIRE = 3, EARTH = 4, STORM = 5, FIREBALL = 6, ROCKFALL = 7, BOMB = 8, MUD = 9, VOLCANO = 10}
var element_1: Element =Element.NULL
var element_2: Element=Element.NULL
var death_step : int = 0

func _ready():
	game.health_depleted.connect(_death)
	for card in card_list:
		card.on_interact_card.connect(_interact_card)
	get_tree().paused = false
	_instance = self if _instance == null else _instance
	
func _interact_card(element: Element):
	if element_1 == element:
		_disable_element(element_1)
		element_1 = element_2
		element_2 = Element.NULL
	elif element_2 == element:
		_disable_element(element_2)
		element_2 = Element.NULL
	elif element_1 == Element.NULL && element_2 == Element.NULL:
		element_1 = element
	elif element_1 != Element.NULL && element_2 == Element.NULL:
		element_2 = element
	else:
		_disable_element(element_1)
		element_1 = element_2
		element_2 = element
		
	#element_1 = element_2
	#element_2 = element
	print("elements: " + Element.keys()[element_1] + ","+Element.keys()[element_2])

func _disable_element(element: Element):
	match element:
			Element.AIR:
				$CardAir.disable()
			Element.WATER:
				$CardWater.disable()
			Element.FIRE:
				$CardFire.disable()
			Element.EARTH:
				$CardEarth.disable()


func _death():
	if death_step == 0:
		print("death!")
		$Player3D.is_input_reading = false
		death_step = 1
	
func _process(delta):
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
		$VoiceMusicPlayer.play()
		print("play")
		
	if timer_counter > 8 && randi_range(1,10) == 3:
		$CreepyMonsterPlayer.play()
		timer_counter = 0
		
	if timer_counter > 8 && randi_range(1,10) == 5:
		$LurkingMonsterPlayer.play()
		timer_counter = 0
	attack()
	
func attack():
	var element_attack: ElementAtt
	var element_list: Array[Element] = [element_1, element_2]
	match element_list:
		[Element.NULL, Element.NULL]:
			element_attack = ElementAtt.NULL
		[Element.NULL, Element.AIR], [Element.AIR, Element.NULL]:
			element_attack = ElementAtt.AIR
		[Element.NULL, Element.WATER], [Element.WATER, Element.NULL]:
			element_attack = ElementAtt.WATER
		[Element.NULL, Element.FIRE], [Element.FIRE, Element.NULL]:
			element_attack = ElementAtt.FIRE
		[Element.NULL, Element.EARTH], [Element.EARTH, Element.NULL]:
			element_attack = ElementAtt.EARTH
			
		[Element.AIR, Element.WATER], [Element.WATER, Element.AIR]:
			element_attack = ElementAtt.STORM
		[Element.AIR, Element.FIRE], [Element.FIRE, Element.AIR]:
			element_attack = ElementAtt.FIREBALL
		[Element.AIR, Element.EARTH], [Element.EARTH, Element.AIR]:
			element_attack = ElementAtt.ROCKFALL
		
		[Element.WATER, Element.FIRE], [Element.FIRE, Element.WATER]:
			element_attack = ElementAtt.VOLCANO
		[Element.WATER, Element.EARTH], [Element.EARTH, Element.WATER]:
			element_attack = ElementAtt.MUD
			
		[Element.FIRE, Element.EARTH], [Element.EARTH, Element.FIRE]:
			element_attack = ElementAtt.BOMB
	print("attack:" + ElementAtt.keys()[element_attack])
	if element_attack != Element.NULL:
		game.attack(element_attack)
