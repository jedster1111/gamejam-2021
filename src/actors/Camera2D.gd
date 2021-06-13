extends Camera2D

onready var shake_timer = get_node("ShakeTimer")
onready var duration_timer = get_node("Duration")
onready var camera_tween = get_node("CameraShake")

const TRANSITION = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

var amplitude = 0
var priority = 0

func start(duration = 0.2, frequency = 15, amplitude = 10, priority = 0):
	if priority >= self.priority:
		self.priority = priority
	
		self.amplitude = amplitude
		duration_timer.wait_time = duration
		if frequency != 0:
			shake_timer.wait_time = 1/ float(frequency)
		shake_timer.start()
		duration_timer.start()
		print("starting")
		_new_shake()

func _new_shake():
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)
	
	camera_tween.interpolate_property(self, "offset", self.offset, rand, shake_timer.wait_time, TRANSITION, EASE)
	camera_tween.start()

func _reset():
	print("resetting")
	amplitude = 0
	camera_tween.interpolate_property(self, "offset", self.offset, Vector2(0,0), shake_timer.wait_time, TRANSITION, EASE)
	camera_tween.stop_all()
	
	priority = 0

func _on_ShakeTimer_timeout():
	_new_shake()


func _on_Duration_timeout():
	print("stoppin")
	_reset()
