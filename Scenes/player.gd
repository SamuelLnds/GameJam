extends Node2D

@export var player : Resource = null

@onready var battle = get_parent()
@onready var enemy

@onready var punch_button = get_parent().get_node('PanelContainer/ActionsPanel/MarginContainer/Actions/Action1')
@onready var kick_button = get_parent().get_node('PanelContainer/ActionsPanel/MarginContainer/Actions/Action2')

@onready var init_position = self.position
@onready var position_after_resize = self.position

@onready var playerAnimations = $PlayerVsplit/AnimationPlayer

var paul_dead = preload("res://Assets/SFX/mort_paul.mp3")
var hartal_on_hit = preload("res://Assets/SFX/seprenduncoup_hartal.mp3")
var paul_win = preload("res://Assets/SFX/victoire_paul.mp3")

@onready var audio_player = $AudioStreamPlayer 

var hasKicked = false

var reference_viewport_size = Vector2(1280, 720)

const punch = 1
const kick = 2

const SPEED = 600

var damage = 0

func _ready():
	punch_button.pressed.connect(_on_action_1_pressed)
	kick_button.pressed.connect(_on_action_2_pressed)
	
	var screen_size = get_viewport().size
	position = Vector2(screen_size.x * 0.25, screen_size.y * 0.5)
	var scale_factor = Vector2(screen_size) / reference_viewport_size
	scale = scale_factor
	position_after_resize = position
	
func _process(_delta):
	pass

func decrease_health(health, max_health, callback):
	var tween = create_tween()
	tween.tween_property($PlayerVsplit/ProgressBar, "value", health, 1.5)
	tween.tween_callback(callback.bind($PlayerVsplit/ProgressBar, health, max_health))

func _on_action_1_pressed():
	_on_action_pressed('punch')
	if hasKicked:
		hasKicked = false
	

func _on_action_2_pressed():
	if not hasKicked:
		_on_action_pressed('kick')
		hasKicked = true

func _on_action_pressed(action_type):
	
	battle.isPlayerTurn = false
	battle.update_button_states()
	await translate_to_mob_front()
	
	if action_type == 'punch':
		damage = State.punch_damage
	elif action_type == 'kick':
		damage = State.kick_damage
		
	await get_tree().create_timer(1.0).timeout
	playerAnimations.play(action_type)
	audio_player.stream = hartal_on_hit
	audio_player.play()
	await playerAnimations.animation_finished
	battle.current_foe_health = max(0, battle.current_foe_health - damage)
		
	battle.set_health(battle.side2, battle.current_foe_health, get_parent().side2.enemy.health)
	playerAnimations.play("RESET")
	await get_tree().create_timer(0.5).timeout

	playerAnimations.play_backwards('walk')
	await get_tree().create_timer(1).timeout
	playerAnimations.play("RESET")
	
	if battle.current_foe_health > 0:
		await battle.pass_turn_to_mob()
		
		

func translate_to_mob_front():
	var tween = create_tween()
	var target_position = enemy.position + Vector2(-150, 0)
	tween.tween_property(self, "position", target_position, 1).set_trans(Tween.TRANS_LINEAR)
	playerAnimations.play("walk")
	tween.tween_interval(1)
	tween.tween_property(self, "position", position_after_resize, 1).set_trans(Tween.TRANS_LINEAR)
