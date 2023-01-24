extends Area2D


export var amm_particles = 0
export var particle_spawn_time = 1
export var particle_radius = 1
export var particle_texture:Texture
export var particle_script:Resource

var particles_needed = 50
var water_particles = []

func _process(delta):
	if particles_needed != 0:
		for i in range(10):
			particles_needed -= 1
			create_rigidbody_instance()
		
func create_rigidbody_instance():
	var particle = RigidBody2D.new()
	var particle_hitbox = CollisionShape2D.new()
	var particle_collision_shape = CircleShape2D.new()
	var particle_texture = Sprite.new()
	var particle_texture_image = Image.new()
	var particle_texture_itex = ImageTexture.new()
	
	particle.position = position
	
	particle_collision_shape.radius = 0.5
	particle_hitbox.shape = particle_collision_shape
	
	particle_texture_image.load("res://water_particle.png") # Change this to some real liquid
	particle_texture_itex.create_from_image(particle_texture_image)
	particle_texture.texture = particle_texture_itex
	
	particle.name = "Water_Particle"
	particle.apply_central_impulse(Vector2(rand_range(-100, 100), rand_range(-100, 0)))
	particle.add_child(particle_hitbox)
	particle.add_child(particle_texture)
	particle.set_script(particle_script)
	
	get_parent().add_child(particle)
