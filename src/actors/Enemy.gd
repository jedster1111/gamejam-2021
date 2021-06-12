extends KinematicBody2D

#onready var player_detector = get_node("playerDetector")
signal shoot(bullet, velocity, location)

var BloodSplatter = preload ("res://src/actors/BloodSplatter.tscn")
const Bullet = preload("res://src/actors/Bullet.tscn")

var max_lives = 1
var lives = 1

var target = null
var hit_pos
var laser_color = Color(1.0, 0.0, 0.0)
var can_shoot = true

func _process(delta):
	update()
	if target:
		aim()

func hit(hit_direction: Vector2):
	var blood = BloodSplatter.instance()
	blood.position += hit_direction.normalized() * 40
	blood.rotation = hit_direction.angle()
	blood.scale *= 1.5
	add_child(blood)
	blood.stop()
	blood.play("default")
	yield(blood, "animation_finished")
	max_lives -= 1

	if max_lives <= 0:
		die()

func die():
	queue_free()


func aim():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position, target.position,
					[self], collision_mask)
	if result:
		hit_pos = result.position
		if result.collider.name == 'Player':
			rotation = (target.position - position).angle()
		if can_shoot:
			shoot()

func _draw():
	if target:
		draw_line(Vector2(), (target.position - position).rotated(-rotation), laser_color)
		draw_circle((hit_pos - position).rotated(-rotation), 5, laser_color)

func shoot():
	print("shooting")
	var bullet = Bullet.instance()
	bullet.velocity = Vector2.UP.rotated(rotation + PI/2) * 1000
	bullet.rotation = bullet.velocity.angle()
	bullet.position = position + bullet.velocity.normalized() * 70
	can_shoot = false
	
	emit_signal("shoot", bullet)

func _on_Visibility_body_entered(body):
	if target:
		return
	target = body
	# Debugging purposes
	$coin.self_modulate.r = 0.2



func _on_Visibility_body_exited(body):
	if body == target:
		target = null
	# Debugging purposes
	$coin.self_modulate.r = 1.0



func _on_Fire_Rate_timeout():
	can_shoot = true
