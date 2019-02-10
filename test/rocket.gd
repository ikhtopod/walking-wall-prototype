extends KinematicBody2D

var start_pos = Vector2()
var end_pos = Vector2()
var direction = Vector2()
var velocity = 300

func _ready():
	set_fixed_process(true)


func _fixed_process(delta):
	move( direction * velocity * delta )
	

func _move(start_p, end_p, vel):
	start_pos = start_p
	end_pos = end_p
	_normalize_velocity(vel)
	_normalize_direction(end_pos, start_pos)


func _normalize_velocity(vel):
	if vel < 300:
		velocity = 300
	elif vel > 1000:
		velocity = 1000
	else:
		velocity = vel

func _normalize_direction(end, start):
	direction = (end_pos - start_pos).normalized()
	
	if direction == Vector2():
		direction = Vector2(0, -1)
		get_node("sprite").set_rotd(180)

