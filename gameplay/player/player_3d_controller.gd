class_name PlayerController
extends CharacterBody3D

@onready var game_menu: Control = $GameMenu

@export_category("Mouse Capture")
@export var CAPTURE_ON_START: bool = true

#Mouvement
@export_group("Movement")
@export var max_speed : float = 4.0
@export var acceleration : float = 15.0
@export var breaking : float = 5.0
@export var air_acceleration : float = 4.0
@export var jump_force : float = 5.0
@export var gravity_modifier : float = 1.5
@export var max_run_speed : float = 6.0
var is_running : bool = false

#Camera
@export_group("Camera")
@export var look_sensitivity : float = 0.005
var camera_look_input : Vector2

@onready var camera : Camera3D = get_node("Camera3D")
@onready var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_modifier

func _ready():
	if Engine.is_editor_hint():
		return
	# Capture mouse if set to true
	if CAPTURE_ON_START:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass
	
func _physics_process(delta):	
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Jumping
	if Input.is_action_pressed("jump") && is_on_floor():
		velocity.y = jump_force
	
	var move_input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var move_dir = (transform.basis * Vector3(move_input.x, 0, move_input.y)).normalized()
	
	is_running = Input.is_action_pressed("sprint")
	var target_speed = max_speed
	if is_running:
		target_speed = max_run_speed
		var run_dot = -move_dir.dot(transform.basis.z)
		run_dot = clamp(run_dot, 0.0, 1.0)
		move_dir *= run_dot
	
	var current_smoothing = acceleration
	
	if not is_on_floor():
		current_smoothing = air_acceleration
	elif not move_dir:
		current_smoothing = breaking
		
	var target_velocity = move_dir * target_speed
	
	velocity.x = lerp(velocity.x, target_velocity.x, current_smoothing * delta)
	velocity.z = lerp(velocity.z, target_velocity.z, current_smoothing * delta)
	move_and_slide()
	
	#Camera look
	rotate_y(-camera_look_input.x * look_sensitivity)

	camera.rotate_x(-camera_look_input.y * look_sensitivity)
	camera.rotation.x = clamp(camera.rotation.x, -1.5, 2.5)
	camera_look_input = Vector2.ZERO
	
func _input(event):
	# Listen for mouse movement and check if mouse is captured
	if event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		camera_look_input = event.relative
	if event.is_action_pressed("pause") and get_tree().paused == false:
		pause()
	pass
	
func pause():
	game_menu.show()
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
