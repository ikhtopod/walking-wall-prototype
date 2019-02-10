extends Node2D

var score = 0
var speed_step = 0.02
var block_load = preload("res://test/block.tscn")

onready var timer_node = get_node("timer")
onready var block_tex_node = get_node("ui/bg/block/tex")
onready var fps_num_node = get_node("ui/top/fps/num")
onready var score_num_node = get_node("ui/top/score/num")

onready var block_width = floor(block_tex_node.get_rect().size.x / 32)
onready var blocks_offset = round((block_tex_node.get_rect().size.x - (block_width*32)) / 2)


func _ready():
	score_num_node.set_text(str(score))
	make_block()
	timer_node.start()


func _on_timer_timeout():
	get_tree().call_group(0, "block", "move")
	make_block()
	
	if timer_node.get_wait_time() < 0.15:
		timer_node.set_wait_time( 0.1 )
	else:
		timer_node.set_wait_time( timer_node.get_wait_time() - speed_step )
	
	fps_num_node.set_text(str(OS.get_frames_per_second()))


func make_block():
	var block_last_created = block_load.instance()
	block_last_created.set_pos( Vector2( 16+blocks_offset, 16+blocks_offset ) )
	block_tex_node.add_child(block_last_created, true)
	
	var prev_block_pos = block_last_created.get_pos()
	for i in range(1, block_width):
		block_last_created = block_load.instance()
		block_last_created.set_pos( prev_block_pos + Vector2(32, 0) )
		prev_block_pos = block_last_created.get_pos()
		block_tex_node.add_child(block_last_created, true)


func accum_score(s):
	score += s
	score_num_node.set_text(str(score))


func _on_collisions_body_enter( body ):
	if body.is_in_group("rocket"):
		body.free()
