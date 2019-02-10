extends Node2D

signal score_add(accum)

var explosion_load = preload("res://test/explosion.tscn")

var score
var dead_position_y

# nodes
var proto_node
var rocket_tex_node
var block_tex_node


func _enter_tree():
	proto_node = get_tree().get_root().get_node("proto")
	rocket_tex_node = proto_node.get_node("ui/bg/rocket/tex")
	block_tex_node = proto_node.get_node("ui/bg/block/tex")
	score = round(rand_range(general.SCORE_MIN, general.SCORE_MAX))
	dead_position_y = block_tex_node.get_rect().size.y - 32
	connect("score_add", proto_node, "accum_score", [score])


func _ready():
	set_process(true)


func _process(delta):
	if get_pos().y >= dead_position_y:
		get_tree().call_deferred("change_scene", "res://test/proto_main_menu.tscn")

func _exit_tree():
	emit_signal("score_add")
	

func move():
	set_pos( get_pos() + Vector2(0, 32) )


func _on_kinematic_body_enter( body ):
	if body.is_in_group("explosion"):
		body.queue_free()
		self.queue_free()
	elif body.is_in_group("rocket"):
		var explosion = explosion_load.instance()
		explosion.set_pos(body.get_pos())
		body.queue_free()
		rocket_tex_node.add_child(explosion, true)
	