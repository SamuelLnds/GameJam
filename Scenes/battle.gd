extends Control

@export var enemy : Resource = null

@onready var punch_button = get_node('PanelContainer/ActionsPanel/MarginContainer/Actions/Action1')
@onready var kick_button = get_node('PanelContainer/ActionsPanel/MarginContainer/Actions/Action2')

@onready var side1 = $Player
@onready var side2

@onready var current_player_health = State.player_health
@onready var current_foe_health

var isPlayerTurn = true

var mob_instance = preload("res://Scenes/mob.tscn")

func _ready():
	
	spawn_enemy()
	
	set_health(side2, side2.enemy.health, side2.enemy.health)
	set_health(side1, State.player_health, State.player_health)
	side2.get_node('EnemyVsplit/Enemy').texture = side2.enemy.texture
	
	update_button_states()
	$Win.hide()
	$Loose.hide()
	

func pass_turn_to_mob():
		isPlayerTurn = false
		update_button_states()
		await side2.attack_player()
		update_button_states()
		

func update_button_states():
	punch_button.disabled = not isPlayerTurn
	kick_button.disabled = not isPlayerTurn or side1.hasKicked

func set_health(side, health, max_health):
	side.decrease_health(health, max_health, bar_update_callback)

	if current_player_health <= 0:
		$Loose.show()
	if current_foe_health == 0:
		await get_tree().create_timer(1.0).timeout		
		side2.foeAnimations.play("enemy_died")
		await get_tree().create_timer(1.0).timeout
		_on_enemy_death()
	
	
func bar_update_callback(progress_bar, health, max_health):
	progress_bar.max_value = max_health
	progress_bar.value = health

func _on_enemy_death():
	side2.queue_free()
	await get_tree().create_timer(2.0).timeout
	spawn_enemy()
	

@onready var enemy_wave = [
	"res://Resources/mob.tres",
	"res://Resources/mob2.tres",
	"res://Resources/Hartal.tres"
]

var current_enemy_index = 0

func spawn_enemy():
	if current_enemy_index < enemy_wave.size():
		var enemy_resource = load(enemy_wave[current_enemy_index])
		var enemy_scene = preload("res://Scenes/mob.tscn")
		var new_enemy = enemy_scene.instantiate()
		new_enemy.enemy = enemy_resource
		add_child(new_enemy)
		side2 = new_enemy
		
		current_foe_health = side2.enemy.health
		side1.enemy = get_node("mob")
		if isPlayerTurn != true:
			isPlayerTurn = true
			update_button_states()
		current_enemy_index += 1
	else:
		$Win.show()

func _on_win_continuer():
	get_tree().quit()
	

func _on_win_rejouer():
	current_enemy_index = 0	
	spawn_enemy()
	
	update_button_states()
	$Win.hide()


func _on_loose_rejouer():
	set_health(side2, side2.enemy.health, side2.enemy.health)
	set_health(side1, State.player_health, State.player_health)
	side2.get_node('EnemyVsplit/Enemy').texture = side2.enemy.texture
	
	update_button_states()
	$Loose.hide()


func _on_title_screen_1_start():
	$"title screen 1".queue_free()
