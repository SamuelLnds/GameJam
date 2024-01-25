extends Node2D 

@export var enemy : Resource = null

var battle
var player 

var reference_viewport_size = Vector2(1280, 720)

func _ready():
	spawn_position()
	battle = get_parent()
	var battle_children = battle.get_children()
	for i in battle_children:
		print("battle_children child: " ,i)
	player = battle.get_node("Player")

func _process(_delta):
	pass

func decrease_health(health, max_health, callback):
	var tween = create_tween()
	tween.tween_property($EnemyVsplit/ProgressBar, "value", health, 1.5)
	tween.tween_callback(callback.bind($EnemyVsplit/ProgressBar, health, max_health))

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
	battle.set_health(get_parent().side1, battle.current_player_health, State.player_max_health)
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
