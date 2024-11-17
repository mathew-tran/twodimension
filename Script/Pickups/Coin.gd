extends Area2D

func _ready():
	$AnimationPlayer.play("animate")


func _on_body_entered(body):
	$CollisionShape2D.queue_free()
	$AudioStreamPlayer2D.play()
	$AnimationPlayer.play("death")
	Helper.GetGame().IncrementCoin()


func _on_audio_stream_player_2d_finished():
	queue_free()
