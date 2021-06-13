extends SlashableBody

signal shoot(bullet, velocity, location)

const Bullet = preload("res://src/actors/Bullet.tscn")

var target = null
var hit_pos
var laser_color = Color(1.0, 0.0, 0.0)
var can_shootROF = true
var is_alert = false
var can_start_shooting = false
var can_see_player = false

func _ready():
	add_to_group("enemies")

func _process(_delta):
	update()
	if target:
		aim()

func get_destruction_scene():
	return load("res://src/actors/BloodSplatter.tscn")

func get_destruction_sound():
	return load("res://assets/audio/Death_2.wav")


func alert():
	is_alert = true
	if $AlertTimer.is_stopped():
		$AlertTimer.start()
		can_start_shooting = false
	yield($AlertTimer, "timeout")
	can_start_shooting = true

func aim():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position, target.position,
					[self], $Visibility.collision_mask)
	if result:
		if result.collider.name == 'Player':
			can_see_player = true
			if is_alert == false:
				alert()
			$Enemy.self_modulate.r = 0.2
			rotation = (target.position - position).angle()
		else:
			can_see_player = false
			is_alert = false
			$Enemy.self_modulate.r = 1.0
			return
		if can_shootROF and can_start_shooting:
			shoot()



func _draw():
	if target and can_see_player:
		draw_line(Vector2(), (target.position - position).rotated(-rotation), laser_color)

func shoot():
	var bullet = Bullet.instance()
	bullet.velocity = Vector2.UP.rotated(rotation + PI/2) * 1000
	bullet.rotation = bullet.velocity.angle()
	bullet.position = position + bullet.velocity.normalized() * 70
	can_shootROF = false
	
	emit_signal("shoot", bullet)

func _on_Visibility_body_entered(body):
	if target:
		return
	if body.name == "Player":
		target = body


func _on_Visibility_body_exited(body):
	if body == target:
		target = null


func _on_Fire_Rate_timeout():
	can_shootROF = true
