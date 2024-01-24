extends Node2D 

@export var enemy : Resource = null

@onready var battle = get_node("..")

var reference_viewport_size = Vector2(1280, 720)

func _ready():
	pass

func _process(_delta):
	
	var screen_size = get_viewport().size
	position = Vector2(screen_size.x * 0.75, screen_size.y * 0.45)
	var scale_factor = Vector2(screen_size) / reference_viewport_size
	scale = scale_factor
	
	if not battle.isPlayerTurn:
		attack_player()
		battle.isPlayerTurn = true

func attack_player():
	battle.current_player_health = max(0, battle.current_player_health - enemy.damage)
	battle.set_health(get_node("../Player/PlayerVsplit/ProgressBar"), battle.current_player_health, State.player_max_health)
