extends StaticBody2D

@export var health = 3

const PARTICLE_SCENE = preload("res://particles.tscn")
const GREEN = preload("res://assets/green.png")
const ORANGE = preload("res://assets/orange.png")
const RED = preload("res://assets/red.png")

func play_sound(sound_path: String):
	var stream = load(sound_path) as AudioStream

	if stream == null:
		print("Failed to load: ", sound_path)
		return

	var player = AudioStreamPlayer.new()
	player.stream = stream

	get_tree().root.add_child(player)

	player.play()
	player.finished.connect(player.queue_free)

func hit():
	health -= 1
	
	if health <= 0:
		play_sound("res://assets/tick.wav")
		var particle = PARTICLE_SCENE.instantiate()
		particle.emitting = true
		particle.global_position = global_position + Vector2(0, 3)
		particle.finished.connect(particle.queue_free)
		get_parent().get_parent().add_child(particle)
		queue_free()
		
	elif health == 2:
		$Sprite2D.texture = ORANGE
	elif health == 1:
		$Sprite2D.texture = RED
