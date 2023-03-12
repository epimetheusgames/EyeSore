extends KinematicBody2D


onready var player_body = get_parent().get_node("Player_Body")
onready var attack_cooldown_timer = get_node("Attack_Cooldown_Timer")

var velocity = Vector2.ZERO
var default_move_speed = 2.2
var curr_move_speed = default_move_speed
var match_player_y = true

export var gravity_strength = 10
export var friction_strength = 20

var attacks = {
	"Ice_Cream_Scoop_fire" : Ice_Cream_Scoop_Fire_Attack(),
	"Spin_Cone" : Spin_Cone_Attack(),
}

var first_phase_attacks = ["Ice_Cream_Scoop_Fire", "Spin_Cone"]

func _ready():
	attack_cooldown_timer.start(5)

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP)
	
	Apply_Friction()
	
	if match_player_y == true:
		if abs(player_body.velocity.y) < 5.5:
			curr_move_speed = move_toward(curr_move_speed, default_move_speed / 1.8, 0.1)
		elif abs(player_body.velocity.y) > 55:
			curr_move_speed = move_toward(curr_move_speed, default_move_speed / 1.2, 0.1)
		
		self.position.y = move_toward(self.position.y, player_body.position.y - 32, curr_move_speed)
	
	# if the attack cooldown timer is at 0, start an attack
	if $Attack_Cooldown_Timer.time_left <= 0:
		# choose a random index of the first_phase_attacks list, then use that as the index for the attacks dictionary, which calls the func for the passed attack
		print(randi() % first_phase_attacks.size())
		var cooldown_to_next_attack = attacks[first_phase_attacks[randi() % first_phase_attacks.size()]]
		attack_cooldown_timer.start(cooldown_to_next_attack)


func Apply_Friction():
	velocity.x = move_toward(velocity.x, 0, friction_strength)

# attack functions
func Ice_Cream_Scoop_Fire_Attack():
	print("Scoop Fire")
	var cooldown_to_next_attack = 5
	return cooldown_to_next_attack

func Spin_Cone_Attack():
	print("Spin_Cone")
	var cooldown_to_next_attack = 5
	return cooldown_to_next_attack
