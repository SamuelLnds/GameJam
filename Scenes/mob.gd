extends Node2D 

@export var enemy : Resource = null

@onready var foeAnimations = $EnemyVsplit/AnimationPlayer

var paul_dead = preload("res://Assets/SFX/mort_paul.mp3")
var hartal_win = preload("res://Assets/SFX/victoire_hartal.mp3")
var paul_on_hit = preload("res://Assets/SFX/seprenduncoup_paul.mp3")
var hartal_walk = preload("res://Assets/SFX/marche_hartal.mp3")

@onready var audio_player = $AudioStreamPlayer 

var battle
var player 

var reference_viewport_size = Vector2(1280, 720)


func _ready():
	spawn_position()
	battle = get_parent()
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
	await get_tree().create_timer(1.0).timeout
	foeAnimations.play("walk")
	await translate_to_player_front()
	
	await get_tree().create_timer(1).timeout
	foeAnimations.play("hit")	
	await get_tree().create_timer(0.5).timeout
	battle.current_player_health = max(0, battle.current_player_health - get_parent().side2.enemy.damage)
	battle.set_health(get_parent().side1, battle.current_player_health, State.player_max_health)
	if get_parent().current_player_health <= 0:
		audio_player.stream = paul_dead
		audio_player.play()
		await get_tree().create_timer(0.5).timeout		
		audio_player.stream = hartal_win
		audio_player.play()
	else:
		audio_player.stream = paul_on_hit
		audio_player.play()
		await get_tree().create_timer(0.75).timeout

		foeAnimations.play_backwards('walk')
		await get_tree().create_timer(1).timeout
		foeAnimations.play("RESET")
		battle.isPlayerTurn = true
	

func translate_to_player_front():
	var tween = create_tween()
	var init_position = self.position
	var target_position = player.position_after_resize + Vector2(150, 0)
	tween.tween_property(self, "position", target_position, 1).set_trans(Tween.TRANS_LINEAR)
	tween.tween_interval(1)
	tween.tween_property(self, "position", init_position, 1).set_trans(Tween.TRANS_LINEAR)
