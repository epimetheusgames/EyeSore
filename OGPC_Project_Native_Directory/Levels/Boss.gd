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
var x_speed = 1
var match_player_y = true

export var gravity_strength = 10
export var friction_strength = 20

# Different attacks that the boss has, reference the README.md or EyeSore ideas doc for more info.
var first_phase_attacks = ["Scoop_Fire", "Cone_Spin"]
var doing_spin_attack = false

func _ready():
	# Start the attack cooldown timer at the start of the level, and player the spawn animation.
	attack_cooldown_timer.start(5)
	state_machine.start("Spawn")

func _physics_process(delta):
	# Move and slide for velocity, aka movement
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# Apply friction to boss
	Apply_Friction()
	
	# If matching player's y (yes) match the boss's y exactly, or move towards it fast enough that
	# the boss never breaks.
	if match_player_y == true:
		if abs(player_body.velocity.y) < 5.5:
			curr_move_speed = move_toward(curr_move_speed, default_y_move_speed / 1.8, 0.1)
		elif abs(player_body.velocity.y) > 55:
			curr_move_speed = move_toward(curr_move_speed, default_y_move_speed / 1.2, 0.1)
		
		self.position.y = move_toward(self.position.y, player_body.position.y - 32, curr_move_speed)
		
	self.position.x -= x_speed
	
	if player_body.position.distance_to(self.position) > 230:
		x_speed += 0.01
	elif player_body.position.distance_to(self.position) < 330 and x_speed >= 1.4:
		x_speed -= 0.02
	
	# if the attack cooldown timer is at 0, start an attack
	if state_machine.get_current_node() == "Idle" and attack_cooldown_timer.time_left <= 0:
		attack_cooldown_timer.start(5)
	if attack_cooldown_timer.time_left <= 1 and state_machine.get_current_node() == "Idle":
		var cooldown_to_next_attack = Start_Attack(first_phase_attacks[(randi() % first_phase_attacks.size())])


func Apply_Friction():
	velocity.x = move_toward(velocity.x, 0, friction_strength)

func Start_Attack(attack_name):
	if attack_name == "Scoop_Fire":
		Scoop_Fire_Attack()
	elif attack_name == "Cone_Spin":
		Cone_Spin_Attack()

# attack functions
func Scoop_Fire_Attack():
	# go to the correct statemachine node
	state_machine.travel("Scoop_Fire_Attack")
	
	for i in range(3):
		for j in range(3):
			var boss_bullet = boss_bullet_file_path.instance()
				
			get_node("/root/MainMenuRootNode/Shooting_SFX_Player").play()
				
			get_parent().add_child(boss_bullet)
				
			boss_bullet.position = $Boss_Gun_Base.global_position
			
			yield(get_tree().create_timer(0.1), "timeout")
		yield(get_tree().create_timer(0.5), "timeout")

func Cone_Spin_Attack():
	# go to the correct statemachine node
	state_machine.travel("Cone_Spin_Attack")
