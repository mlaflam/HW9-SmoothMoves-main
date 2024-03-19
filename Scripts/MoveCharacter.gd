extends CharacterBody2D
var gravity : Vector2 
@export var jump_height : float ## How high should they jump?
@export var movement_speed : float ## How fast can they move?
@export var horizontal_air_coefficient : float ## Should the player move more slowly left and right in the air? Set to zero for no movement, 1 for the same
@export var speed_limit : float ## What is the player's max speed? 
@export var friction : float ## What friction should they experience on the ground?

# Called when the node enters the scene tree for the first time.
# This function sets the initial gravity
func _ready():
	gravity = Vector2(0, 100)  # Gravity is 0 in x direction and 100 in y direction
	# note that positive y velocity indicates downwrard movement
	# so gravity is automatically pulling the character down 
	pass 

# Function that gets player input (such as pressing right or left key) to determine the character movement
func _get_input():
	
	 # if the Character is on the "floor" or has ended vertical motion
	if is_on_floor():
		
		# if moving left then add negative of the movement speed to the velocity in the x direction 
		# negative changes of velocity in the x direction indicate leftward movement
		if Input.is_action_pressed("move_left"):
			velocity += Vector2(-movement_speed,0)

		# if moving right then add positive of the movement speed to the velocity in the x direction 
		# positive changes of velocity in the x direction indicate rigthward movement
		if Input.is_action_pressed("move_right"):
			velocity += Vector2(movement_speed,0)
		
		# if jumping then negatve of jump height to the velocity in the y direction 
		# negatve changes of velocity in the y direction indicate upward movement
		# also adds 1 to velocity in x direction (moves slightly right to give jump a horizontal push)
		if Input.is_action_just_pressed("jump"): # Jump only happens when we're on the floor (unless we want a double jump, but we won't use that here)
			velocity += Vector2(100,-jump_height)
	
	# if the Character is NOT on the "floor" or has NOT ended motion
	if not is_on_floor():
		# if moving left then add negative of the movement speed to the velocity in the x direction 
		# negative changes of velocity in the x direction indicate leftward movement
		# this is multipied by the horizontal_air_coefficient which lessens x movement in the air
		if Input.is_action_pressed("move_left"):
			velocity += Vector2(-movement_speed * horizontal_air_coefficient,0)
	
		# if moving right then add positive of the movement speed to the velocity in the x direction 
		# positive changes of velocity in the x direction indicate rigthward movement
		# this is multipied by the horizontal_air_coefficient which lessens x movement in the air
		if Input.is_action_pressed("move_right"):
			velocity += Vector2(movement_speed * horizontal_air_coefficient,0)

# Function to limit player movement speed
# this makes it so that the character doesnt get too fast in any direction 
func _limit_speed():
	
	# this is for rightward movement 
	# if the velocity in the x direction is greater than the speed limit 
	# then decrease the velocity in the x direction back down to the speed limit 
	# additionally maintain the 
	if velocity.x > speed_limit: 
		velocity = Vector2(speed_limit, velocity.y)
	
	# if the velocity in the x direction is greater than the negative speed limit 
	# then decrease the velocity in the x direction back down to the speed limit 
	# additionally maintain the 
	if velocity.x < -speed_limit:
		velocity = Vector2(-speed_limit, velocity.y)

# Function to apply friction to character movement on the floor
# this makes it so the character doesnt constantly slide around
func _apply_friction():
	# Applying friction only when on ground and not cirrently moving
	if is_on_floor() and not (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
		velocity -= Vector2(velocity.x * friction, 0)
		if abs(velocity.x) < 5: # If velocity is <5, stop movement
			velocity = Vector2(0, velocity.y) # if the velocity in x gets close enough to zero, we set it to zero

# Function to apply gravity to the character 
# only goes into effect when the player is not on the floor (airborne)
# applying gravity forces the player slowly downward as they are in the air 
func _apply_gravity():
	if not is_on_floor():
		velocity += gravity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_get_input() # Get player input
	_limit_speed() # Limit speed
	_apply_friction() # Apply friction
	_apply_gravity() # Apply gravity

	move_and_slide()
	pass
