extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var mouse_sensitivity: float = 0.2 #ToDo: config


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	# only consider mouse motion
	var mouse_motion = event as InputEventMouseMotion
	if not mouse_motion:
		return
	
	# rotation horizontal
	rotation_degrees.y -= mouse_motion.relative.x * mouse_sensitivity
	
	# rotation vertical
	%Camera3D.rotation_degrees.x -= mouse_motion.relative.y * mouse_sensitivity
	
	# clamp vertical rotation
	if %Camera3D.rotation_degrees.x < -90:
		%Camera3D.rotation_degrees.x = -90
	elif %Camera3D.rotation_degrees.x > 90:
		%Camera3D.rotation_degrees.x = 90


