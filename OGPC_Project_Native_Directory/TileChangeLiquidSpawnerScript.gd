extends Area2D

# This is the script responsible for spawning the liquid that changes tiles
# NOT the script that changes the tiles when the liquid touches it. Don't get 
# confused like I do everyday.

# Ammount of particles that it spawns
export var amm_particles = 10
# How many particles spawn every frame (60 frames per second)
export var particle_spawn_per_frame = 1
# The radius of the particle (For big water if that's needed.)
export var particle_radius = 1
# The image of the particle
export var particle_texture:Texture
# Script that the particle has.
export var particle_script:Resource
# If it sprays out, which is not neccesary for regular water.
export var spray = true
# Do the particles dissapear when they touch the ground?
export var dissapear = true
# I guess the image size or something.
export var particle_size = 0.5

var water_particles = []

func _process(delta):
	# Create particles here unless they are already created.
	if amm_particles >= 0:
		for i in range(particle_spawn_per_frame):
			amm_particles -= 1
			create_rigidbody_instance()
	else:
		self.queue_free()

func create_rigidbody_instance():
	# Script for creating one particle
	
	# The root node for the particle (not really root ig)
	var particle = RigidBody2D.new()
	# The hitbox of the particle
	var particle_hitbox = CollisionShape2D.new()
	# The collision shape for the hitbox
	var particle_collision_shape = CircleShape2D.new()
	# Texture for the particle, but a node
	var particle_texture = Sprite.new()
	# The image that is attached to the sprite
	var particle_texture_image = Image.new()
	# I guess the image has a texture, coming back to this code, 
	# I think I just copied it off the docs.
	var particle_texture_itex = ImageTexture.new()
	
	particle.position = position
	
	particle_collision_shape.radius = particle_size
	particle_hitbox.shape = particle_collision_shape
	
	# Load texture from path.
	particle_texture_image.load("res://water_particle.png") 
	particle_texture_itex.create_from_image(particle_texture_image)
	particle_texture.texture = particle_texture_itex
	particle_texture.centered = true
	particle_texture.scale = Vector2(particle_size, particle_size)
	
	particle.name = "Water_Particle"
	particle.position += Vector2(rand_range(-5, 5), rand_range(-5, 5))
	
	if spray:
		particle.apply_central_impulse(Vector2(rand_range(-100, 100), rand_range(-100, 0)))
	
	# Add all those nodes as children.
	particle.add_child(particle_hitbox)
	particle.add_child(particle_texture)
	
	if dissapear:
		particle.set_script(particle_script)
	
	# Bam add it as a sibling of the spawner.
	get_parent().add_child(particle)
