extends Node2D

@export var player : Resource = null

@onready var battle = get_parent()
@onready var enemy = get_parent().get_node("Mob")

@onready var punch_button = get_parent().get_node('PanelContainer/ActionsPanel/MarginContainer/Actions/Action1')
@onready var kick_button = get_parent().get_node('PanelContainer/ActionsPanel/MarginContainer/Actions/Action2')

@onready var init_position = self.position


var reference_viewport_size = Vector2(1280, 720)

const punch = 1
const kick = 2

const SPEED = 600

var damage = 0

func _ready():
	punch_button.pressed.connect(_on_action_1_pressed)
	kick_button.pressed.connect(_on_action_2_pressed)


func _process(_delta):
	pass

func _on_action_1_pressed():
	_on_action_pressed(punch)

func _on_action_2_pressed():
	_on_action_pressed(kick)

func _on_action_pressed(action_type):
	
	battle.isPlayerTurn = false
	battle.update_button_states()
	await translate_to_mob_front()
	
	await get_tree().create_timer(1.0).timeout

	if action_type == punch:
		damage = State.punch_damage
		print("Punch: ", State.punch_damage)
	elif action_type == kick:
		damage = State.kick_damage
		print("Kick: ", State.kick_damage)

	battle.current_foe_health = max(0, battle.current_foe_health - damage)
		
	battle.set_health(battle.get_node("Mob/EnemyVsplit/ProgressBar"), battle.current_foe_health, get_parent().side2.enemy.health)
	print("Set health")

	if battle.current_foe_health > 0:
		await battle.pass_turn_to_mob()

func translate_to_mob_front():
	var tween = create_tween()
	var target_position = enemy.position + Vector2(-150, 0)
	tween.tween_property(self, "position", target_position, 1).set_trans(Tween.TRANS_LINEAR)
	tween.tween_interval(1)
	tween.tween_property(self, "position", init_position, 1).set_trans(Tween.TRANS_LINEAR)
