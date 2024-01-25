extends Control

signal start

func _start():
	var viewport_size = get_viewport().size
	self.rect_size = viewport_size

func _on_button_pressed():
	emit_signal("start")
