extends CharacterBody2D

@export var speed: float = 200.0
var shooter: Node2D

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		var collider = collision.get_collider()
		
		if collider.name == "GPUParticles2D":
			return
		
		if collider.name == "KillZone":
			queue_free()
			return
	
		velocity = velocity.bounce(collision.get_normal())
		if collider.has_method("hit"):
			collider.hit()
