shader_type canvas_item;

uniform vec4 first_color : source_color = vec4(1.0);
uniform vec4 second_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float size : hint_range(0, .5) = 0.5;

void fragment() {
    // Calculate the distance from the center
    float distance = length(UV - vec2(.5, .5));

    // Use the step function to create a hard line between two colors
    float pos = step(0.5 - size, distance);
    
    // Mix the two colors based on the step function result
    COLOR = mix(first_color, second_color, pos);
	COLOR.a = 0.5;
}