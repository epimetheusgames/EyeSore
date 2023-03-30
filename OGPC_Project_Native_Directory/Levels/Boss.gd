extends KinematicBody2D


# the file path to instance the boss bullets, the bullets are reused from the old player bullets that were scrapped
const boss_bullet_file_path = preload("res://Player_Bullet.tscn")

# set the playback var, this is a component of the animation tree
onready var state_machine = $AnimationTree.get("parameters/playback")
onready var player_body = get_parent().get_node("Player_Body")
onready var attack_cooldown_timer = $Attack_Cooldown_Timer
onready var attack_duration_timer = $Attack_Duration_Timer
onready var spin_cone = $Spin_Cone

var velocity = Vector2.ZERO
var default_move_speed = 2.4
var curr_move_speed = default_move_speed
var match_player_y = true

export var gravity_strength = 10
export var friction_strength = 20

var first_phase_attacks = ["Scoop_Fire", "Cone_Spin"]
var doing_spin_attack = false

func _ready():
	attack_cooldown_timer.start(5)
	state_machine.start("Spawn")

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP)
	
	Apply_Friction()
	
	if match_player_y == true:
		if abs(player_body.velocity.y) < 5.5:
			curr_move_speed = move_toward(curr_move_speed, default_move_speed / 1.8, 0.1)
		elif abs(player_body.velocity.y) > 55:
			curr_move_speed = move_toward(curr_move_speed, default_move_speed / 1.2, 0.1)
		
		self.position.y = move_toward(self.position.y, player_body.position.y - 32, curr_move_speed)
		
		if self.velocity.x >= 0:
			self.position.x = move_toward(self.position.x, player_body.position.x, curr_move_speed / 2)


func Apply_Friction():
	velocity.x = move_toward(velocity.x, 0, friction_strength)

func Start_Attack(attack_name):
	if attack_name == "Scoop_Fire":
		Scoop_Fire_Attack()
		yield(Scoop_Fire_Attack(), "completed")
	elif attack_name == "Cone_Spin":
		Cone_Spin_Attack()
		yield(Cone_Spin_Attack(), "completed")
	
	attack_cooldown_timer.start(3)

# attack functions
func Scoop_Fire_Attack():
	for i in range(5):
		var boss_bullet = boss_bullet_file_path.instance()
			
		get_node("/root/MainMenuRootNode/Shooting_SFX_Player").play()
			
		get_parent().add_child(boss_bullet)
			
		boss_bullet.position = $Boss_Gun_Base.global_position
		
		yield(get_tree().create_timer(0.5), "timeout")
	
	var cooldown_to_next_attack = 5
	return cooldown_to_next_attack

func Cone_Spin_Attack():
	$Label.text = "cone_spin"
	attack_duration_timer.start(8)
	# Set the animationtree's animation here
	state_machine.travel("Cone_Spin_Attack")
	yield($AnimationPlayer, "animation_finished")
	$Label.text = "idle"
	state_machine.travel("Idle")
	var cooldown_to_next_attack = 3
	return cooldown_to_next_attack

# if the attack cooldown timer is at 0, start an attack
func _on_Attack_Cooldown_Timer_timeout():
	var cooldown_to_next_attack = Start_Attack(first_phase_attacks[(randi() % first_phase_attacks.size())])
	attack_cooldown_timer.start()
