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
var x_speed = 1.6
var match_player_y = true
var original_pos = Vector2(400, 32)

export var gravity_strength = 10
export var friction_strength = 20

# Different attacks that the boss has, reference the README.md or EyeSore ideas doc for more info.
var first_phase_attacks = ["Scoop_Fire", "Cone_Spin"]
var attacking = false

var spawned = false

func reset():
	attacking = false
	position = Vector2((player_body.position.x + 170), player_body.position.y)
	x_speed = 1.1
	attack_cooldown_timer.start(4)
	# TODO make it reset asll attributes when going back to spawn so it doesn't end up with a half visible attack element or anything
	spin_cone.modulate.a = 0
	state_machine.travel("Spawn")

func _ready():
	# Start the attack cooldown timer at the start of the level, and play the spawn animation.
	self.hide()
	$CollisionShape2D.disabled = true

func _physics_process(delta):
	if state_machine.get_current_node() != "Spawn" and state_machine.is_playing() and spawned:
		# Move and slide for velocity, aka movement
		velocity = move_and_slide(velocity, Vector2.UP)
		
#		var player_direction = (position - get_parent().get_node("Player_Body").position).normalized()
#		rotation = atan2(player_direction.y, player_direction.x)
		
		self.position.y = (player_body.position.y - 20)
		
		# Move position to follow the player on the x axis
		self.position.x -= x_speed
		if player_body.position.distance_to(self.position) > 210:
			x_speed += 0.09
		elif player_body.position.distance_to(self.position) < 110 and x_speed >= 0.5:
			x_speed -= 0.1
		
		# if the attack cooldown timer is at 0, start an attack
		if state_machine.get_current_node() == "Idle" and attack_cooldown_timer.time_left <= 0:
			attack_cooldown_timer.start(4)
		if attack_cooldown_timer.time_left <= 1 and state_machine.get_current_node() == "Idle":
			var cooldown_to_next_attack = Start_Attack(first_phase_attacks[(randi() % first_phase_attacks.size())])

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
			
			yield(get_tree().create_timer(0.2), "timeout")
		yield(get_tree().create_timer(0.6), "timeout")

func Cone_Spin_Attack():
	# go to the correct statemachine node
	state_machine.travel("Cone_Spin_Attack")

func Spawn_Boss():
	self.show()
	$CollisionShape2D.disabled = false
	attack_cooldown_timer.start(4)
	state_machine.travel("Spawn")
	velocity.x = -40
	spawned = true
