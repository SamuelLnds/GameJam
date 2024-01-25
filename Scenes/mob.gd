extends Node2D 

@export var enemy : Resource = null

@onready var battle = get_parent()
@onready var player = battle.get_node("Player")

var reference_viewport_size = Vector2(1280, 720)

func _ready():
	spawn_position()

func _process(_delta):
	pass

func spawn_position():
	var screen_size = get_viewport().size
	position = Vector2(screen_size.x * 0.75, screen_size.y * 0.5)
	var scale_factor = Vector2(screen_size) / reference_viewport_size
	scale = scale_factor

func attack_player():
	await get_tree().create_timer(2.0).timeout
	translate_to_player_front()
	await get_tree().create_timer(1.0).timeout
	battle.current_player_health = max(0, battle.current_player_health - get_parent().side2.enemy.damage)
	battle.set_health(get_node("../Player/PlayerVsplit/ProgressBar"), battle.current_player_health, State.player_max_health)
	await get_tree().create_timer(2).timeout	
	print("It's the player's turn")
	battle.isPlayerTurn = true

func translate_to_player_front():
	var tween = create_tween()
	var init_position = self.position
	var target_position = player.position_after_resize + Vector2(300, 0)
	tween.tween_property(self, "position", target_position, 1).set_trans(Tween.TRANS_LINEAR)
	tween.tween_interval(1)
	tween.tween_property(self, "position", init_position, 1).set_trans(Tween.TRANS_LINEAR)
