extends Node

var game_time = 65
var time = game_time
var level = 1

const GAME = preload("res://game.tscn")
var game

func start_game():
	var time_reduction = level * 5
	time = game_time - time_reduction
	game = GAME.instantiate()
	add_child(game)
	
func game_over():
	level = 1
	time = 999
	game.queue_free()
	game = null
	var restart_time = 5
	$GameOverLabel.text = "Game Over.\nRestarting in %s seconds" % restart_time
	while restart_time > 0:
		await get_tree().create_timer(1).timeout
		restart_time -= 1
		$GameOverLabel.text = "Game Over.\nRestarting in %s seconds" % restart_time
	$GameOverLabel.text = ""
	start_game()

func game_win():
	level += 1
	time = 999
	game.queue_free()
	game = null
	var restart_time = 5
	$GameOverLabel.text = "You Win!\nContinuing in %s seconds" % restart_time
	while restart_time > 0:
		await get_tree().create_timer(1).timeout
		restart_time -= 1
		$GameOverLabel.text = "You Win!\nContinuing in %s seconds" % restart_time
	$GameOverLabel.text = ""
	start_game()

func _ready():
	var timer := Timer.new()
	timer.wait_time = 1.0
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	
	start_game()
	
func _process(_delta):
	if game:
		game.get_node("HUD").get_node("TimeLabel").text = "time: %s" % time
		game.get_node("HUD").get_node("LevelLabel").text = "level: %s" % level
	
		if game.get_node("Grid").get_child_count() == 0:
			game_win()

func _on_timer_timeout():
	time -= 1
	if time <= 0:
		game_over()
