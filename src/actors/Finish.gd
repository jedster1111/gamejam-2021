extends StaticBody2D

signal levelcomplete

func _on_PlayerDetector_body_entered(_body):
	print("Level complete")
	emit_signal("levelcomplete")
