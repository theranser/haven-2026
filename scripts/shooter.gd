extends Node2D

@export var balls = 15
@export var balls_per_shot = 5

@export var ball_speed = 200.0
@export var ball_size = 0.2

const MAX_LENGTH = 75.0
const BALL_SCENE = preload("res://ball.tscn")

var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	$Line2D.add_point(Vector2.ZERO)
	$Line2D.add_point(Vector2.ZERO)
	
	var timer := Timer.new()
	timer.wait_time = 0.5
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func _process(_delta):
	var start_pos: Vector2 = global_position
	var mouse_pos: Vector2 = get_global_mouse_position()
	
	direction = start_pos.direction_to(mouse_pos)
	var end_pos: Vector2 = start_pos + (direction * MAX_LENGTH)

	$Line2D.set_point_position(1, to_local(end_pos))
		
	%BallsLabel.text = "balls: %s" % balls

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			if balls >= balls_per_shot:
				%BallsLabel.add_theme_color_override("font_color", Color.WHITE)
				var current_direction = direction
				balls -= balls_per_shot
				for i in range(balls_per_shot):
					var ball = BALL_SCENE.instantiate()
					ball.scale = Vector2(ball_size, ball_size)
					ball.global_position = global_position
					ball.velocity = current_direction * ball_speed
					ball.shooter = self
					get_parent().add_child(ball)
					
					await get_tree().create_timer(0.2).timeout
					
func _on_timer_timeout():
	balls += 1
	if balls >= 20:
		balls = 20
		%BallsLabel.add_theme_color_override("font_color", Color.RED)
	else:
		%BallsLabel.add_theme_color_override("font_color", Color.WHITE)
