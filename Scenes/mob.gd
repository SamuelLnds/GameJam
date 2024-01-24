extends Node2D 

@export var enemy : Resource = null

@onready var battle = $/root/Battle

var is_player_turn: bool = true

func _ready():
	pass

func _process(_delta):
	if not is_player_turn:
		attack_player()
		is_player_turn = true

func attack_player():
	battle.current_player_health = max(0, battle.current_player_health - enemy.damage)
	print("Enemy attacks! Player health is now ", battle.current_player_health)
	battle.set_health($Player/PlayerVsplit/ProgressBar, battle.current_player_health, State.player_max_health)
	is_player_turn = true
