extends MeshInstance2D

var state_machine


var player_in_view = false
var shader_fill_value = 0.5

func _ready():
	state_machine = get_parent().get_node("StateMachine")
	material.set_shader_parameter("size", 0.5)
	
func _process(delta):
	material.set_shader_parameter("size", shader_fill_value)

func _on_player_detected():
	if state_machine.get_current_state_name() == "Idle":
		state_machine.transition_to("Fill")
	
func _on_player_not_detected():
	if state_machine.get_current_state_name() == "Fill":
		state_machine.transition_to("Idle")
