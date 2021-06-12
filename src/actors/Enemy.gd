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
var can_shootROF = true
var is_alert = false
var can_start_shooting = false

func _process(_delta):
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

func alert():
	is_alert = true
	if $AlertTimer.is_stopped():
		$AlertTimer.start()
		can_start_shooting = false
	print($AlertTimer.get_time_left())
	yield($AlertTimer, "timeout")
	can_start_shooting = true
	print("timed out")

func aim():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position, target.position,
					[self], $Visibility.collision_mask)
	if result:
		if result.collider.name == 'Player':
			if is_alert == false:
				print("I could not see you before but now i can")
				alert()
			$coin.self_modulate.r = 0.2
			rotation = (target.position - position).angle()
		else:
			is_alert = false
			$coin.self_modulate.r = 1.0
			return
		if can_shootROF and can_start_shooting:
			print("shooting")
			shoot()
			


func _draw():
	if target:
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
