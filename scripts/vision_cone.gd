extends Node2D

var ray_cast : RayCast2D
var mesh_instance : MeshInstance2D

@export var outer_circle_range = 200.0
@export var inner_circle_range = 15.0
@export var vision_angle = 90.0
@export var num_rays = 1000

var direction_angle = 0
var player_in_view = false
var value = 0.5

func _ready():
	ray_cast = $RayCast2D
	mesh_instance = $MeshInstance2D
	var mesh = ImmediateMesh.new()
	mesh_instance.mesh = mesh
	mesh_instance.material.set_shader_parameter("size", 0.5)

func _process(_delta):
	if direction_angle >= 360:
		direction_angle = 0
	update_vision_cone()
	print(player_in_view)
	if player_in_view:
		value -= .005
		mesh_instance.material.set_shader_parameter("size", value)
	else:
		if value < 0.5:
			value += .01
			mesh_instance.material.set_shader_parameter("size", value)

func update_vision_cone():
	var vertices = []
	
	for i in range(num_rays):
		var vision_range = outer_circle_range
		var angle = lerp((360.0 / 2) + direction_angle, (-360.0 / 2) + direction_angle, i / float(num_rays - 1))
		var direction = Vector2(cos(deg_to_rad(angle)), sin(deg_to_rad(angle)))
		if angle <= (vision_angle / 2) + direction_angle and  angle >= (-vision_angle / 2) + direction_angle:
			vision_range = outer_circle_range
		#elif angle <= vision_angle - (vision_angle / 4) + angle_to_mouse and  angle >= -vision_angle + (vision_angle / 4) + angle_to_mouse:
			#vision_range = mid_circle_range
		else:
			vision_range = inner_circle_range
		ray_cast.target_position = direction.normalized() * vision_range
		ray_cast.force_raycast_update()

		if ray_cast.is_colliding():
			var collider = ray_cast.get_collider()
			if collider and collider.has_method("get_name") and collider.get_name() == "Player":
				player_in_view = true
			else:
				player_in_view = false
			var vector_length = (global_position - ray_cast.get_collision_point()).length()
			vertices.append(direction.normalized() * vector_length)
		else:
			var end_pos = ray_cast.get_target_position()
			vertices.append(end_pos)
			

	
	update_mesh(vertices)


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

func calculate_uv(vertex):
	var uv_x = (vertex.x + outer_circle_range) / (2.0 * outer_circle_range)
	var uv_y = (vertex.y + outer_circle_range) / (2.0 * outer_circle_range)

	uv_x = clamp(uv_x, 0.0, 1.0)
	uv_y = clamp(uv_y, 0.0, 1.0)

	return Vector2(uv_x, uv_y)
