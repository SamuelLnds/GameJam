extends Node2D

@export var player : Resource = null

@onready var battle = get_parent()
@onready var enemy = get_parent().get_node("Mob")

@onready var punch_button = get_parent().get_node('PanelContainer/ActionsPanel/MarginContainer/Actions/Action1')
@onready var kick_button = get_parent().get_node('PanelContainer/ActionsPanel/MarginContainer/Actions/Action2')

var reference_viewport_size = Vector2(1280, 720)

const punch = 1
const kick = 2

const SPEED = 600

var damage = 0

func _ready():
	punch_button.pressed.connect(_on_action_1_pressed)
	kick_button.pressed.connect(_on_action_2_pressed)


func _process(_delta):
	var screen_size = get_viewport().size
	position = Vector2(screen_size.x * 0.25, screen_size.y * 0.45) 
	var scale_factor = Vector2(screen_size) / reference_viewport_size
	scale = scale_factor


func _on_action_1_pressed():
	_on_action_pressed(punch)

func _on_action_2_pressed():
	_on_action_pressed(kick)

func _on_action_pressed(action_type):
	
	translate_to_mob_front()
	
	await get_tree().create_timer(1.0).timeout

	if battle.isPlayerTurn:
		if action_type == punch:
			damage = State.punch_damage
		elif action_type == kick:
			damage = State.kick_damage

		battle.current_foe_health = max(0, battle.current_foe_health - damage)
		battle.set_health(battle.get_node("Mob/EnemyVsplit/ProgressBar"), battle.current_foe_health, get_parent().enemy.health)

		print("Passed the turn!")
		battle.pass_turn_to_mob()

func translate_to_mob_front():
	var tween = get_tree().create_tween()
	var init_position = self.position
	var target_position = enemy.position + Vector2(-150, 0)
	tween.tween_property(self, "position", target_position, 1).set_trans(Tween.TRANS_LINEAR)
	await get_tree().create_timer(1.0).timeout	
	tween.tween_property(self, "position", init_position, 1).set_trans(Tween.TRANS_LINEAR)
