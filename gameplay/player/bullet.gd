extends CharacterBody2D

enum Element {AIR, WATER, FIRE, EARTH}
var direction: Vector2 = Vector2(0,0)
var speed: int = 500
var bullet_owner: String = ""
var element : Element


func _ready():
	var style_box : StyleBoxFlat = StyleBoxFlat.new()
	style_box.set_corner_radius_all(50)
	match element:
		Element.AIR:
			style_box.bg_color = Color.GRAY
		Element.WATER:
			style_box.bg_color = Color.BLUE
		Element.FIRE:
			style_box.bg_color = Color.RED
		Element.EARTH:
			style_box.bg_color = Color.BROWN
	$BulletArea/Panel.add_theme_color_override("", Color.BLUE)

func _physics_process(delta):
	self.velocity = direction*speed
	move_and_slide()
	

func _on_bullet_area_body_entered(body):
	if body.is_in_group("Monster"):
		if bullet_owner == "Player":
			self.queue_free()

