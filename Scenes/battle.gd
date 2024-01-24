extends Control

@export var enemy : Resource = null

@onready var punch_button = $PanelContainer/ActionsPanel/MarginContainer/Actions/Action1
@onready var kick_button = $PanelContainer/ActionsPanel/MarginContainer/Actions/Action2

var current_player_health = 0
var current_foe_health = 0

var side1
var side2

const punch = 1
const kick = 2

var isPlayerTurn = true

func _ready():
	set_health($Mob/EnemyVsplit/ProgressBar, enemy.health, enemy.health)
	set_health($Player/PlayerVsplit/ProgressBar, State.player_health, State.player_health)
	$Mob/EnemyVsplit/Enemy.texture = enemy.texture
	
	current_player_health = State.player_health
	current_foe_health = enemy.health
	
	side1 = $Player
	side2 = $Mob

func _on_action_1_pressed():
	_on_action_pressed(punch)

func _on_action_2_pressed():
	_on_action_pressed(kick)
	
func _on_action_pressed(action_type):
	
	# Animation player mouvement
	# Animation player coup
	
	var damage = 0
	if action_type == punch:
		damage = State.punch_damage
	elif action_type == kick:
		damage = State.kick_damage

	current_foe_health = max(0, current_foe_health - damage)
	set_health($Mob/EnemyVsplit/ProgressBar, current_foe_health, enemy.health)
	
	# Animation player mouvement
	
	# Animation mob mouvement
	
	pass_turn_to_mob()
	
	if current_foe_health <= 0:
		print("Player won")
		
	if current_player_health <= 0:
		print("Player died...")
		get_tree().quit()
	
	# Animation mob coup
	# Animation mob mouvement
	
	# GERER LA BARRE DE VIE PAR NODE (PLAYER / MOB)

func pass_turn_to_mob():
		isPlayerTurn = false
		await get_tree().create_timer(2.0).timeout	
		side2.attack_player()

func set_health(progress_bar, health, max_health):
	var tween = create_tween()
	tween.tween_property(progress_bar, "value", health, 1.5)
	tween.tween_callback(toto.bind(progress_bar, health, max_health))
	
	
	if progress_bar == $Mob/EnemyVsplit/ProgressBar:
		print("Foe health: " , health)
	else:
		print("Player health: " , health)
	
	
func toto(progress_bar, health, max_health):
	progress_bar.max_value = max_health
	progress_bar.value = health
	
	# CHANGER ETAT VARIABLE APRES TIMEOUT
	
#func enemy_turn():
	#current_player_health = max(0, current_player_health - enemy.damage)
	#set_health($Player/PlayerVsplit/ProgressBar, current_player_health, State.player_max_health)
	#isPlayerTurn = true
	#
