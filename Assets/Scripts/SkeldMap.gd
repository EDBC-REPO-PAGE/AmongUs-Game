extends Spatial

var alerts = JavaScript.create_object('Object')
var camera = JavaScript.create_object('Array')
var tasks = JavaScript.create_object('Object')
var utils = JavaScript.create_object('Object')
var vents = JavaScript.create_object('Array')
var size = self.scale

func parse( name ):
	var reg = RegEx.new() ; reg.compile("\\w[^_\\d]+")
	var result = reg.search( name )
	if result: return result.strings[0]
	else:      return ''

func _getVec3( args ):
	var result = JavaScript.create_object('Array',3)
	result[0] = args.x; result[1] = args.y; 
	result[2] = args.z; return result

func _ready():
	
	#cameras
	for group in get_node("cameras").get_children():
		var cam = JavaScript.create_object('Object')
		cam.pos = _getVec3(group.translation*size)
		cam.id = group.get_instance_id()
		camera.push(cam)
		
	#tasks
	for group in get_node("tasks").get_children():
		var name = parse(group.get_name())
		tasks[name] = JavaScript.create_object('Array')
		for task in group.get_children():
			var tsk = JavaScript.create_object('Object')
			tsk.pos = _getVec3(task.translation*size)
			tsk.id = task.get_instance_id()
			tasks[name].push(tsk)
	
	#tasks
	for group in get_node("alert").get_children():
		var name = parse(group.get_name())
		alerts[name] = JavaScript.create_object('Array')
		for alert in group.get_children():
			var alr = JavaScript.create_object('Object')
			alr.pos = _getVec3(alert.translation*size)
			alr.id = alert.get_instance_id()
			alerts[name].push(alr)
	
	#utils
	for group in get_node("utils").get_children():
		var name = parse(group.get_name())
		utils[name] = JavaScript.create_object('Object')
		utils[name].pos = _getVec3(group.translation*size)
		utils[name].id = group.get_instance_id()
	
	#vents
	for group in get_node("vents").get_children():
		var g_vents = JavaScript.create_object('Array')
		for vent in group.get_children():
			var vnt = JavaScript.create_object('Object')
			vnt.pos = _getVec3(vent.translation*size)
			vnt.id = vent.get_instance_id()
			g_vents.push(vnt)
		vents.push(g_vents)

	var win = JavaScript.get_interface('window')
	win.godot.task = JavaScript.create_object('Object');
	win.godot.task['alerts'] = alerts
	win.godot.task['camera'] = camera
	win.godot.task['tasks'] = tasks
	win.godot.task['utils'] = utils
	win.godot.task['vents'] = vents
