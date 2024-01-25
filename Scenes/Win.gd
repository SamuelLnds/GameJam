extends Control

signal continuer
signal rejouer

func _start():
	var viewport_size = get_viewport().size
	self.rect_size = viewport_size

func _on_continuer_pressed():
	emit_signal("continuer")


func _on_rejouer_pressed():
	emit_signal("rejouer")
