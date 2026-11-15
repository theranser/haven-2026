extends Node2D

func _ready():
	const SQUARE_SCENE = preload("res://square.tscn")

	var noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.frequency = 0.2
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX

	for vertical in range(9):
		for horizontal in range(12):

			var noise_value = noise.get_noise_2d(
				vertical,
				horizontal
			)

			if noise_value < -0.05:
				continue

			var square = SQUARE_SCENE.instantiate()
			square.position = Vector2(
				vertical * 24 - 96,
				horizontal * 24 - 180
			)

			add_child(square)
