extends Area2D


var spawned = false

func _on_BossSpawnArea_body_entered(body):
	if "Player_Body" in body.name and not "Boss_Body" in body.name and not spawned:
		get_parent().get_node("Boss_Body").Spawn_Boss()
		spawned = true
