extends KinematicBody

#------------Variables------------#
var mouse_sensitivity = 0.2
var SPEED = 20
var SPRINT_SPEED = 40
var ACCEL = 10.0
var GRAVITY = -55.0
var JUMP_SPEED = 20
var jump_counter = 0
var AIR_ACCEL = 15.0
var wallrun_delay = 0.2
var wallJump_h_power = 2.2
var wallJump_v_power = 1.1
export (float, 0, 1) var wall_jump_factor = 0.4
var wallrun_angle = 15
var wallrun_current_angle = 0
var side = ""


#Booleans
var can_wallrun = false
var is_wallrunning = false
var is_wallrunning_jump = false


#Vector Variables
var velocity = Vector3.ZERO
var velocity_info = Vector3.ZERO
var current_vel = Vector3.ZERO
var dir = Vector3.ZERO
var snap = Vector3.ZERO
var wall_jump_dir = Vector3.ZERO

#Referential Variables
onready var camera = $CamRoot/WallRun/Camera
onready var head = $CamRoot
onready var wallRun_node = $CamRoot/WallRun
onready var headbob_anim = $CamRoot/WallRun/Camera/AnimationPlayer
onready var PauseUI = "../Pause UI"
onready var wallrun_delay_default = wallrun_delay



#------------Functions------------#

#Input Event Function
func _input(event):
	mouseInput(event)


#Physics Process Function
func _physics_process(delta):
	#Set movement Function
	movement(delta)
	#Set Jump and Gravity Function
	jumpAndGravity(delta)
	#Set WallRunning Function
	wallRun()
	#Set WallRun Rotation 
	wallRunRotation(delta)
	#Set Void Fall
	voidFall()


#------------Custom Functions------------#

#Jumping and Gravity Function
func jumpAndGravity(delta):	
	if is_on_floor():
		jump_counter = 0
		velocity.y = -0.01
		
		can_wallrun = false
		is_wallrunning = false 
		is_wallrunning_jump = false 
		wallrun_delay = wallrun_delay_default
	else:
		velocity.y += GRAVITY * delta
		
		wallrun_delay = clamp(wallrun_delay - delta, 0, wallrun_delay_default)
		
		if wallrun_delay == 0:
			can_wallrun = true
	
	#Wall Jump
	if Input.is_action_just_pressed("jump") and is_wallrunning:
		can_wallrun = false
		is_wallrunning = false
		
		current_vel = Vector3.ZERO
		
		velocity.y = JUMP_SPEED * wallJump_v_power
		is_wallrunning_jump = true
		
		if side == "LEFT":
			wall_jump_dir = global_transform.basis.x * wallJump_h_power
		elif side == "RIGHT":
			wall_jump_dir = -global_transform.basis.x * wallJump_h_power
		
		wall_jump_dir *= wall_jump_factor
		
		if is_wallrunning_jump:
			dir = (dir * (1 - wall_jump_factor)) + wall_jump_dir
			return
			
	
	
	
	# Jump
	if Input.is_action_just_pressed("jump") and jump_counter < 2:
		jump_counter += 1
		velocity.y = JUMP_SPEED
		snap = Vector3.ZERO
	else:
		snap = Vector3.DOWN


#Movement Function
func movement(delta):

	# Get the input directions
	dir = Vector3.ZERO
	
	if Input.is_action_pressed("forward"):
		dir -= global_transform.basis.z
	if Input.is_action_pressed("backward"):
		dir += global_transform.basis.z
	if Input.is_action_pressed("right"):
		dir += global_transform.basis.x
	if Input.is_action_pressed("left"):
		dir -= global_transform.basis.x
	
	# Normalizing the input directions
	dir = dir.normalized()
	
	# Set speed and target velocity
	var speed = SPRINT_SPEED if Input.is_action_pressed("sprint") else SPEED
	var target_vel = dir * speed
	
	# Smooth out the player's movement
	var accel = ACCEL if is_on_floor() else AIR_ACCEL
	current_vel = current_vel.linear_interpolate(target_vel, accel * delta)
	
	velocity.x = current_vel.x
	velocity.z = current_vel.z
	
	velocity_info = move_and_slide_with_snap(velocity, snap, Vector3.UP, true, 4, deg2rad(45))
	
	#Movement Effects e,g Sprint FOV, Headbob
	movementEffects(delta)


#Movement Effects e.g Sprint FOV, Headbob 
func movementEffects(delta):
	#HeadBob
	if velocity_info.length() < 3.0 or !is_on_floor() and !is_wallrunning:
		headbob_anim.play("Headbob", 0.1, 0.2)
	elif velocity_info.length() <= SPEED:
		headbob_anim.play("Headbob", 0.1, 1.0)
	else:
		headbob_anim.play("Headbob", 0.1, 1.5)
	
	#Sprinting Effect
	#if SPEED == SPRINT_SPEED and velocity_info.length() > 3.0 and !is_wallrunning:
	if Input.is_action_pressed("sprint"):
		camera.fov = lerp(camera.fov, 80, 10 * delta)
	else:
		camera.fov = lerp(camera.fov, 70, 10 * delta)


#Capture Mouse Input
func mouseInput(event):
	if event is InputEventMouseMotion:
		# Rotates the view vertically
		head.rotate_x(deg2rad(event.relative.y * mouse_sensitivity * -1))
		head.rotation_degrees.x = clamp(head.rotation_degrees.x, -75, 75)
		# Rotates the view horizontally
		self.rotate_y(deg2rad(event.relative.x * mouse_sensitivity * -1))



#Wall Run
func wallRun():
	if can_wallrun:
		if is_on_wall() and Input.is_action_pressed("forward") and Input.is_action_pressed("sprint"):
			var collision = get_slide_collision(0)
			var normal = collision.normal
			var wallrun_dir = Vector3.UP.cross(normal)
			var playerview_dir = -camera.global_transform.basis.z
			var dot = wallrun_dir.dot(playerview_dir)
			
			if dot < 0:
				 wallrun_dir = -wallrun_dir
				
			#Calculate Angle
			var wallrun_axis_2d = Vector2(wallrun_dir.x, wallrun_dir.z )
			var view_dir_2d = Vector2(playerview_dir.x, playerview_dir.z)
			var angle = wallrun_axis_2d.angle_to(view_dir_2d)
			
			angle = rad2deg(angle)
			if dot < 0:
				angle = -angle
			
			if angle > 85:
				is_wallrunning = false
				return
				
			wallrun_dir += -normal * 0.01
			
			is_wallrunning = true
			
			side = get_side(collision.position)
			
			velocity.y = -0.01
			dir = wallrun_dir
		else:
			is_wallrunning = false


#Get Sides on which we are wallrunning
func get_side(point):
	point = to_local(point)
	
	if point.x > 0:
		return "RIGHT"
	elif point.x < 0:
		return "LEFT"
	else:
		return "CENTER"


#Wall Run Camera Rotation
func wallRunRotation(delta):
	if is_wallrunning:
		if side == "RIGHT":
			wallrun_current_angle += delta * 60
			wallrun_current_angle = clamp(wallrun_current_angle, -wallrun_angle, wallrun_angle)
		elif side == "LEFT":
			wallrun_current_angle -= delta * 60
			wallrun_current_angle = clamp(wallrun_current_angle, -wallrun_angle, wallrun_angle)
	else:
		if wallrun_current_angle > 0:
			wallrun_current_angle -= delta * 40
			wallrun_current_angle = max(0, wallrun_current_angle)
		elif wallrun_current_angle < 0:
			wallrun_current_angle += delta * 40
			wallrun_current_angle = min(wallrun_current_angle, 0)
			
	wallRun_node.rotation_degrees = Vector3(0 ,0 ,1) * wallrun_current_angle


#Void Fall Function
func voidFall():
	if translation.y < -5 :
		get_tree().reload_current_scene()


