extends StaticBody2D

signal level_complete

func _on_PlayerDetector_body_entered(_body):
	emit_signal("level_complete")
