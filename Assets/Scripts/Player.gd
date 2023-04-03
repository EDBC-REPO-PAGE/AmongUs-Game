extends RigidBody

onready var cam = get_node("Collision/Camera")
onready var ply = get_node("Collision")

var status = {
	'origin': [ self.translation, self.rotation ],
	'sensibility': 0, 'move': false, 'mouse': false,
	'speed': 0, 'angle': 0, 'relative': Vector2(0,0), 
};

#────────────────────────────────────────────────────────────────────#	
	
func _input(event):
	if event is InputEventMouseMotion:
		status.relative.x = event.relative.x * status.sensibility;
		status.relative.y = event.relative.y * status.sensibility;

func _process(delta):
	if status.mouse: moviment( delta )
	if status.move: mouseEvent( delta )

#────────────────────────────────────────────────────────────────────#	

func mouseEvent(delta):
	status.relative.y -= 10 * status.relative.y * delta
	status.relative.x -= 10 * status.relative.x * delta
	cam.rotation.x-= status.relative.y ; ply.rotation.y-=status.relative.x
	cam.rotation.x = clamp( cam.rotation.x, deg2rad( 0 ), deg2rad( 180 ) )
	
func moviment(delta): 
	var ply = get_node("Collision").rotation
	var angle = status.angle ; var speed = status.speed*delta
	self.linear_velocity.x = speed * sin( ply.y + angle )
	self.linear_velocity.z = speed * cos( ply.y + angle )
