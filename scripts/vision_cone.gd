extends Node2D

signal player_detected
signal player_not_detected
signal player_spotted

var ray_cast : RayCast2D
var mesh_instance : MeshInstance2D

@export var outer_circle_range := 200.0
@export var inner_circle_range := 15.0
@export var vision_angle := 90.0
@export var num_rays := 1000
@export var shader_fill_amount = .005
@export var shader_reduce_amount = .01

@onready var game_manager = get_node("/root/GameManager")

var direction_angle = 0
var player_in_view = false

func _ready():
	ray_cast = $RayCast2D
	mesh_instance = $MeshInstance2D
	var mesh = ImmediateMesh.new()
	mesh_instance.mesh = mesh
	connect("player_spotted", game_manager.on_player_spotted)

func _process(_delta):
	if direction_angle >= 360:
		direction_angle = 0
	cast_vision_rays()

## Cast Vision Rays and create a list of vertices for updating the mesh
func cast_vision_rays():
	var vertices = []
	var collisions = []
	
	for i in range(num_rays):
		var vision_range = outer_circle_range
		var angle = lerp((360.0 / 2) + direction_angle, (-360.0 / 2) + direction_angle, i / float(num_rays - 1))
		var direction = Vector2(cos(deg_to_rad(angle)), sin(deg_to_rad(angle)))
		## if the angle is within the vision angle and the view direction, set 
		## vision range to the farthest possible distance, else use the shortest
		## possible distance
		if angle <= (vision_angle / 2) + direction_angle and  angle >= (-vision_angle / 2) + direction_angle:
			vision_range = outer_circle_range
		else:
			vision_range = inner_circle_range
		ray_cast.target_position = direction.normalized() * vision_range
		ray_cast.force_raycast_update()
	
		if ray_cast.is_colliding():
			if ray_cast.get_collider().is_in_group("Short Obstacle"):
				var end_pos = ray_cast.get_target_position()
				vertices.append(end_pos)
			else:
				var vector_length = (global_position - ray_cast.get_collision_point()).length()
				vertices.append(direction.normalized() * vector_length)
				collisions.append(ray_cast.get_collider())
		else:
			var end_pos = ray_cast.get_target_position()
			vertices.append(end_pos)
	
	#check_for_player(collisions)	
	update_mesh(vertices)

# Build a mesh based on the vertices provided by the Raycast
func update_mesh(vertices):
	var mesh = mesh_instance.mesh
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)

	for i in range(1, len(vertices)):
		var vertex_a = Vector2(0.5, 0.5)
		var vertex_b = vertices[i]
		var vertex_c = vertices[i - 1]

		var uv_a = vertex_a
		var uv_b = calculate_uv(vertex_b)
		var uv_c = calculate_uv(vertex_c)
		
		mesh.surface_set_uv(uv_a)
		mesh.surface_add_vertex_2d(vertex_a)
		mesh.surface_set_uv(uv_b)
		mesh.surface_add_vertex_2d(vertex_b)
		mesh.surface_set_uv(uv_c)
		mesh.surface_add_vertex_2d(vertex_c)

	mesh.surface_end()

## Calculate the legth of the vertex and map it to the UV
func calculate_uv(vertex):
	var uv_x = (vertex.x + outer_circle_range) / (2.0 * outer_circle_range)
	var uv_y = (vertex.y + outer_circle_range) / (2.0 * outer_circle_range)

	uv_x = clamp(uv_x, 0.0, 1.0)
	uv_y = clamp(uv_y, 0.0, 1.0)

	return Vector2(uv_x, uv_y)

## Check if player is detected by the Raycast
func check_for_player(collisions):
	var has_player = 0
	for col in collisions:
		if col and col.has_method("get_name") and col.get_name() == "Player":
			has_player += 1

	if has_player > 0:
		emit_signal("player_detected")
	else:
		emit_signal('player_not_detected')

func on_player_spotted():
	emit_signal('player_spotted')
