extends StaticBody2D


func _physics_process(delta):
	$Line2D.points[0] = to_local(self.global_position)
	if $PinJoint2D.node_b:
		$Line2D.points[1] = to_local(get_node($PinJoint2D.node_b).global_position)
