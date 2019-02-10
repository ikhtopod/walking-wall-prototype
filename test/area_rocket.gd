extends Area2D

signal end_pos_signal(end_p)

onready var start_pos = Vector2()
# onready var cur_pos = Vector2()
onready var end_pos = Vector2()
onready var is_touching = false
onready var line_color = Color(1.0, 1.0, 1.0, 1.0)
onready var line_width = 2.0

var rocket_scene = preload("res://test/rocket.tscn")

# nodes
onready var proto_node = get_tree().get_root().get_node("proto")
onready var size_vec_num_node = proto_node.get_node("ui/top/size_vector/num")
onready var rocket_tex_node = proto_node.get_node("ui/bg/rocket/tex")

var size_vector = 0.0


func _enter_tree():
	connect("end_pos_signal", self, "_end_pos_event")


func _ready():
	set_process_input(true)


func _input_event(viewport, event, shape_idx):
	if event.type == InputEvent.SCREEN_TOUCH:
		if event.is_pressed():
			is_touching = true
			start_pos = event.pos
		else:
			if is_touching:
				is_touching = false
				emit_signal("end_pos_signal", event.pos)
				# get_tree().call_deferred("emit_signal", "end_pos_signal", event.pos)


func _input(event):
	if event.type == InputEvent.SCREEN_TOUCH:
		if not event.is_pressed() and is_touching:
			is_touching = false
			emit_signal("end_pos_signal", event.pos)
			# get_tree().call_deferred("emit_signal", "end_pos_signal", event.pos)


func _end_pos_event(end_p):
	end_pos = end_p
	size_vector = start_pos.distance_to(end_pos)  # or (end_pos - start_pos).length()
	size_vec_num_node.set_text(str(size_vector))
	
	var new_rocket = rocket_scene.instance()
	new_rocket.set_pos(start_pos)
	new_rocket.get_node("sprite").look_at(end_pos)
	rocket_tex_node.add_child(new_rocket, true)
	new_rocket._move(start_pos, end_pos, size_vector * 2)
