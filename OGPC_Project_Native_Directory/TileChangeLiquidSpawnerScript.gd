extends Area2D


export var amm_particles = 500
export var particle_spawn_per_frame = 10
export var particle_radius = 1
export var particle_texture:Texture
export var particle_script:Resource
export var spray = true
export var dissapear = true
export var particle_size = 0.5

var water_particles = []

func _process(delta):
	if amm_particles >= 0:
		for i in range(particle_spawn_per_frame):
			amm_particles -= 1
			create_rigidbody_instance()
	else:
		self.queue_free()

func create_rigidbody_instance():
	var particle = RigidBody2D.new()
	var particle_hitbox = CollisionShape2D.new()
	var particle_collision_shape = CircleShape2D.new()
	var particle_texture = Sprite.new()
	var particle_texture_image = Image.new()
	var particle_texture_itex = ImageTexture.new()
	
	particle.position = position
	
	particle_collision_shape.radius = particle_size
	particle_hitbox.shape = particle_collision_shape
	
	particle_texture_image.load("res://water_particle.png") # Change this to some real liquid
	particle_texture_itex.create_from_image(particle_texture_image)
	particle_texture.texture = particle_texture_itex
	particle_texture.centered = true
	particle_texture.scale = Vector2(particle_size, particle_size)
	
	particle.name = "Water_Particle"
	particle.position += Vector2(rand_range(-5, 5), rand_range(-5, 5))
	
	if spray:
		particle.apply_central_impulse(Vector2(rand_range(-100, 100), rand_range(-100, 0)))
		
	particle.add_child(particle_hitbox)
	particle.add_child(particle_texture)
	
	if dissapear:
		particle.set_script(particle_script)
	
	get_parent().add_child(particle)
