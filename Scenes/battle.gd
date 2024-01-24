extends Control

@export var enemy : Resource = null

@onready var punch_button = get_node('PanelContainer/ActionsPanel/MarginContainer/Actions/Action1')
@onready var kick_button = get_node('PanelContainer/ActionsPanel/MarginContainer/Actions/Action2')

@onready var player = $Player

var current_player_health = 0
var current_foe_health = 0

var side1
var side2

var isPlayerTurn = true

func _ready():
	
	
	set_health($Mob/EnemyVsplit/ProgressBar, enemy.health, enemy.health)
	set_health($Player/PlayerVsplit/ProgressBar, State.player_health, State.player_health)
	$Mob/EnemyVsplit/Enemy.texture = enemy.texture
	
	current_player_health = State.player_health
	current_foe_health = enemy.health
	
	update_button_states()
	
	side1 = $Player
	side2 = $Mob
	

#func _on_action_1_pressed():
#	_on_action_pressed(punch)
#
#func _on_action_2_pressed():
#	_on_action_pressed(kick)
#
#func _on_action_pressed(action_type):
#
#	var damage = 0
#
#	if isPlayerTurn == true:
#		if action_type == punch:
#			damage = State.punch_damage
#		elif action_type == kick:
#			damage = State.kick_damage
#
#		current_foe_health = max(0, current_foe_health - damage)
#		set_health($Mob/EnemyVsplit/ProgressBar, current_foe_health, enemy.health)
#
#		pass_turn_to_mob()
#		isPlayerTurn = true
#		update_button_states()
#
#	else:
#		pass
#
#	if current_foe_health <= 0:
#		print("Player won")
#
#	if current_player_health <= 0:
#		print("Player died...")
#		get_tree().quit()
#
#	# Animation mob coup
#	# Animation mob mouvement
	
func pass_turn_to_mob():
		isPlayerTurn = false
		update_button_states()
		await get_tree().create_timer(2.0).timeout	
		side2.attack_player()

func update_button_states():
	punch_button.disabled = not isPlayerTurn
	kick_button.disabled = not isPlayerTurn

func set_health(progress_bar, health, max_health):
	var tween = create_tween()
	tween.tween_property(progress_bar, "value", health, 1.5)
	tween.tween_callback(bar_update_callback.bind(progress_bar, health, max_health))
	
	
	if progress_bar == $Mob/EnemyVsplit/ProgressBar:
		print("Foe health: " , health)
	else:
		print("Player health: " , health)
	
	
func bar_update_callback(progress_bar, health, max_health):
	progress_bar.max_value = max_health
	progress_bar.value = health
