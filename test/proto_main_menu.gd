extends Control

onready var proto_scene = preload("res://test/proto.tscn")


func _on_game_pressed():
	get_tree().call_deferred("change_scene_to", proto_scene)


func _on_exit_pressed():
	get_tree().call_deferred("quit")
