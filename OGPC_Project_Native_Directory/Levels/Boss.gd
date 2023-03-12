extends KinematicBody2D


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

func _ready():
	attack_cooldown_timer.start(5)
	spin_cone.hide()

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP)
	
	Apply_Friction()
	
	if match_player_y == true:
		if abs(player_body.velocity.y) < 5.5:
			curr_move_speed = move_toward(curr_move_speed, default_move_speed / 1.8, 0.1)
		elif abs(player_body.velocity.y) > 55:
			curr_move_speed = move_toward(curr_move_speed, default_move_speed / 1.2, 0.1)
		
		self.position.y = move_toward(self.position.y, player_body.position.y - 32, curr_move_speed)
	
	$Label.text = str(attack_cooldown_timer.time_left)


func Apply_Friction():
	velocity.x = move_toward(velocity.x, 0, friction_strength)

func Start_Attack(attack_name):
	if attack_name == "Scoop_Fire":
		Scoop_Fire_Attack()
	elif attack_name == "Cone_Spin":
		Cone_Spin_Attack()

# attack functions
func Scoop_Fire_Attack():
	print("Scoop Fire")
	var cooldown_to_next_attack = 5
	return cooldown_to_next_attack

func Cone_Spin_Attack():
	spin_cone.show()
	attack_duration_timer.start(8)
	while attack_duration_timer.time_left > 0:
		spin_cone.rotation_degrees += 0.1
	spin_cone.hide()
	var cooldown_to_next_attack = 5
	return cooldown_to_next_attack

# if the attack cooldown timer is at 0, start an attack
func _on_Attack_Cooldown_Timer_timeout():
	var cooldown_to_next_attack = Start_Attack(first_phase_attacks[randi() % first_phase_attacks.size()])
	attack_cooldown_timer.start()
