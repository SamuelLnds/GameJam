extends Control

@export var enemy : Resource = null

@onready var punch_button = get_node('PanelContainer/ActionsPanel/MarginContainer/Actions/Action1')
@onready var kick_button = get_node('PanelContainer/ActionsPanel/MarginContainer/Actions/Action2')

@onready var side1 = $Player
@onready var side2

@onready var current_player_health = State.player_health
@onready var current_foe_health

@onready var audio_player = side1.get_node('AudioStreamPlayer') 
@onready var music_player = $AudioStreamPlayer 

@onready var dialog = $PanelContainer/Dialog/MarginContainer/Barnabe/Label
@onready var barnabe = $PanelContainer/Dialog/MarginContainer/Barnabe/Sprite2D

var hartal_dead = preload("res://Assets/SFX/mort_hartal.mp3")
var paul_win = preload("res://Assets/SFX/victoire_paul.mp3")

var music_win = preload("res://Assets/SFX/win.mp3")
var music_lose = preload("res://Assets/SFX/lose.mp3")

var isPlayerTurn = true

var mob_instance = preload("res://Scenes/mob.tscn")


func _ready():
	
	punch_button.disabled = true
	kick_button.disabled = true


func set_text(text: String, char_delay: float = 0.025):
	dialog.text = ""
	for char in text:
		dialog.text += char
		await get_tree().create_timer(char_delay).timeout


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
		music_player.stream = music_lose
		music_player.play()
		$Loose.show()
	if current_foe_health == 0:
		await get_tree().create_timer(1.0).timeout		
		side2.foeAnimations.play("enemy_died")
		await side2.foeAnimations.animation_finished
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
		audio_player.stream = hartal_dead
		audio_player.play()
		$Win.show()
		music_player.stream = music_win
		music_player.play()
		await get_tree().create_timer(1.0).timeout		
		audio_player.stream = paul_win
		audio_player.play()

func _on_win_continuer():
	get_tree().quit()
	

func _on_win_rejouer():
	if side2 != null:
		side2.queue_free()
	current_enemy_index = 0	
	update_button_states()
	
	$Win.hide()
	spawn_enemy()


func _on_loose_rejouer():
	side2.queue_free()
	set_health(side1, State.player_health, State.player_health)
	side2.get_node('EnemyVsplit/Enemy').texture = side2.enemy.texture
	
	update_button_states()
	$Loose.hide()
	
	spawn_enemy()
	
	


func _on_title_screen_1_start():
	$Loose.hide()
	$Win.hide()
	$"title screen 1".queue_free()


	await set_text('Bienvenue sur Quest of Time ! Je m’appelle Barnabé et je vais te guider tout au long de ta quête.')
	await get_tree().create_timer(2.0).timeout
	barnabe.frame = 2
	await set_text('Paul vient de se faire voler son royaume par la chevalière princesse Odette, il est donc revenu à une très ancienne époque.')
	await get_tree().create_timer(2.0).timeout			
	barnabe.frame = 1	
	await set_text('Afin que Paul récupère son Royaume aide le à combattre ses différents ennemis, pour qu’il traverse les frontières du temps.')
	await get_tree().create_timer(1.0).timeout			
	
	set_health(side1, State.player_health, State.player_health)
	
	update_button_states()
	
	
	spawn_enemy()
	
	barnabe.frame = 0	
	await set_text('Pour combattre, il s’agit de tour par tour, tu commences le combat. Sélectionne une attaque. ->')
	await get_tree().create_timer(5.0).timeout			
	set_text('...')	
