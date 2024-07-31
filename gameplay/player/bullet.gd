extends CharacterBody2D

var air_texture = preload("res://assets/sprites/cloud.png")
var water_texture = preload("res://assets/sprites/water.png")
var fire_texture = preload("res://assets/sprites/fire.png")
var earth_texture = preload("res://assets/sprites/dirt.png")
var storm_texture = preload("res://assets/sprites/storm.png")
var fireball_texture = preload("res://assets/sprites/fireball.png")
var rock_texture = preload("res://assets/sprites/rock.png")
var bomb_texture = preload("res://assets/sprites/bomb.png")
var mud_texture = preload("res://assets/sprites/sand.png")
var volcano_texture = preload("res://assets/sprites/volcano.png")

enum ElementAtt {NULL = 0, AIR = 1, WATER = 2, FIRE = 3, EARTH = 4, STORM = 5, FIREBALL = 6, ROCKFALL = 7, BOMB = 8, MUD = 9, VOLCANO = 10}
var direction: Vector2 = Vector2(0,0)
var speed: int = 500
var bullet_owner: String = ""
var element : ElementAtt


func _ready():
	var style_box : StyleBoxFlat = StyleBoxFlat.new()
	style_box.set_corner_radius_all(50)
	match element:
		ElementAtt.AIR:
			$BulletArea/Sprite2D.texture = air_texture
		ElementAtt.WATER:
			$BulletArea/Sprite2D.texture = water_texture
		ElementAtt.FIRE:
			$BulletArea/Sprite2D.texture = fire_texture
		ElementAtt.EARTH:
			$BulletArea/Sprite2D.texture = earth_texture
		ElementAtt.STORM:
			$BulletArea/Sprite2D.texture = storm_texture
		ElementAtt.FIREBALL:
			$BulletArea/Sprite2D.texture = fireball_texture
		ElementAtt.ROCKFALL:
			$BulletArea/Sprite2D.texture = rock_texture
		ElementAtt.BOMB:
			$BulletArea/Sprite2D.texture = bomb_texture
		ElementAtt.MUD:
			$BulletArea/Sprite2D.texture = mud_texture
		ElementAtt.VOLCANO:
			$BulletArea/Sprite2D.texture = volcano_texture

func _physics_process(delta):
	self.velocity = direction*speed
	move_and_slide()
	

func _on_bullet_area_body_entered(body):
	if body.is_in_group("Monster"):
		if bullet_owner == "Player":
			self.queue_free()

