extends Control

@export var enemy : Resource = null

@onready var punch_button = get_node('PanelContainer/ActionsPanel/MarginContainer/Actions/Action1')
@onready var kick_button = get_node('PanelContainer/ActionsPanel/MarginContainer/Actions/Action2')

@onready var side1 = $Player
@onready var side2 = $Mob

@onready var current_player_health = State.player_health
@onready var current_foe_health = side2.enemy.health

@onready var isPlayerTurn = true

func _ready():
	
	set_health($Mob/EnemyVsplit/ProgressBar, side2.enemy.health, side2.enemy.health)
	set_health($Player/PlayerVsplit/ProgressBar, State.player_health, State.player_health)
	$Mob/EnemyVsplit/Enemy.texture = side2.enemy.texture
	
	update_button_states()
	

	
func pass_turn_to_mob():
		isPlayerTurn = false
		update_button_states()
		await side2.attack_player()
		update_button_states()
		

func update_button_states():
	punch_button.disabled = not isPlayerTurn
	kick_button.disabled = not isPlayerTurn

func set_health(progress_bar, health, max_health):
	print("function set health started")
	var tween = create_tween()
	tween.tween_property(progress_bar, "value", health, 1.5)
	tween.tween_callback(bar_update_callback.bind(progress_bar, health, max_health))

	if current_player_health <= 0:
		print("Player died...")
		await get_tree().create_timer(2.0).timeout			
		get_tree().quit()
	if current_foe_health == 0:
		print("Player won!")
		
		await get_tree().create_timer(2.0).timeout		
		get_tree().quit()
	
	if progress_bar == $Mob/EnemyVsplit/ProgressBar:
		print("Foe health: " , health)
	else:
		print("Player health: " , health)
	
	
func bar_update_callback(progress_bar, health, max_health):
	progress_bar.max_value = max_health
	progress_bar.value = health
