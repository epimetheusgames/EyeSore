extends KinematicBody2D


# the file path to instance the boss bullets, the bullets are reused from the old player bullets that were scrapped
const boss_bullet_file_path = preload("res://Boss_Bullet.tscn")

# set the playback var, this is a component of the animation tree
onready var state_machine = $AnimationTree.get("parameters/playback")

# Player body variable
onready var player_body = get_parent().get_node("Player_Body")

# Timer for different attack cooldowns, so they don't go emedietely. 
onready var attack_cooldown_timer = $Attack_Cooldown_Timer

# Timer for the duration of the attack.
onready var attack_duration_timer = $Attack_Duration_Timer

# The cone that spins and kills you.
onready var spin_cone = $Spin_Cone

var velocity = Vector2.ZERO
var default_y_move_speed = 3
var curr_move_speed = default_y_move_speed 

# How fast the boss moves towards the player
var x_speed = 1.2
var match_player_y = true
var original_pos = Vector2(400, 32)

export var gravity_strength = 10
export var friction_strength = 20

# Different attacks that the boss has, reference the README.md or EyeSore ideas doc for more info.
var first_phase_attacks = ["Scoop_Fire", "Ice_Cream_Blinding_Vignette", "Cone_Spin"]
var attacking = false

var spawned = false

func reset():
	attacking = false
	position = Vector2((player_body.position.x + 170), player_body.position.y)
	x_speed = 1
	attack_cooldown_timer.start(4)
	# TODO make it reset asll attributes when going back to spawn so it doesn't end up with a half visible attack element or anything
	# Done for spin cone, when attacks are revamped will likely need to do again, also technically doesn't reset spin cone position just modulate so the player can't see it
	spin_cone.modulate.a = 0
	state_machine.stop()
	state_machine.start("Spawn")

func _ready():
	# Start the attack cooldown timer at the start of the level, and play the spawn animation.
	self.hide()
	randomize()
	$Spin_Cone/Spin_Cone_Collider.disabled = true
	$CollisionShape2D.disabled = true

func _physics_process(delta):
	$CollisionShape2D.disabled = false
	
	if state_machine.get_current_node() != "Spawn" and state_machine.is_playing() and spawned:
		# Move and slide for velocity, aka movement
		velocity = move_and_slide(velocity, Vector2.UP)
		
#		var player_direction = (position - get_parent().get_node("Player_Body").position).normalized()
#		rotation = atan2(player_direction.y, player_direction.x)
		
		if match_player_y == true:
			self.position.y = move_toward(self.position.y, (player_body.position.y - 20), 10)
		
		# Move position to follow the player on the x axis
		self.position.x -= x_speed
		if player_body.position.distance_to(self.position) > 320:
			x_speed += 0.009
		elif player_body.position.distance_to(self.position) < 290 and x_speed >= 0.52:
			x_speed -= 0.02
		
		# if the attack cooldown timer is at 0, start an attack
		if state_machine.get_current_node() == "Idle" and attacking == false and attack_cooldown_timer.time_left <= 0:
			attack_cooldown_timer.start(8)
		if attack_cooldown_timer.time_left <= 1 and state_machine.get_current_node() == "Idle":
			var cooldown_to_next_attack = Start_Attack(first_phase_attacks[(randi() % first_phase_attacks.size())])

func Start_Attack(attack_name):
	if attack_name == "Scoop_Fire":
		Scoop_Fire_Attack()
	elif attack_name == "Cone_Spin":
		Cone_Spin_Attack()
	elif attack_name == "Ice_Cream_Blinding_Vignette":
		Ice_Cream_Blinding_Vignette()
	
	randomize()

# attack functions
func Scoop_Fire_Attack():
	attacking = true
	# go to the correct statemachine node
	state_machine.travel("Scoop_Fire_Attack")
	
	for i in range(3):
		if (self.position.x - 20) > player_body.position.x:
			match_player_y = false
			self.position.y = player_body.position.y - 120 + (i * 25)
			for j in range(3):
				var boss_bullet = boss_bullet_file_path.instance()
					
				get_node("/root/MainMenuRootNode/Shooting_SFX_Player").play()
					
				get_parent().add_child(boss_bullet)
					
				boss_bullet.position = $Boss_Gun_Base.global_position
				
				yield(get_tree().create_timer(0.1), "timeout")
				self.position.y += 60
			match_player_y = true
			yield(get_tree().create_timer(0.9), "timeout")
	
	attacking = false

func Cone_Spin_Attack():
	attacking = true
	$Spin_Cone/Spin_Cone_Collider.disabled = false
	# go to the correct statemachine node
	state_machine.travel("Cone_Spin_Attack")
	yield(get_tree().create_timer(8), "timeout")
	$Spin_Cone/Spin_Cone_Collider.disabled = true
	attacking = false

func Ice_Cream_Blinding_Vignette():
	attacking = true
	state_machine.travel("Ice_Cream_Blinding_Attack")
	player_body.get_node("Death_Anim_Transition").show()
	player_body.get_node("Death_Anim_Transition/Death_Vignette_Player").play("Death_Vignette")
	yield(get_tree().create_timer(3), "timeout")
	player_body.get_node("Death_Anim_Transition/Death_Vignette_Player").stop(true)
	player_body.get_node("Death_Anim_Transition").stop_anim()
	player_body.get_node("Death_Anim_Transition").hide()
	attacking = false

func Spawn_Boss():
	self.show()
	attack_cooldown_timer.start(4)
	state_machine.travel("Spawn")
	velocity.x = -40
	spawned = true
