shader_type canvas_item;


uniform float height: hint_range(0.0, 1.0, 0.1) = 0.5;
uniform float width: hint_range(0.0, 1.0, 0.1) = 0.5;


void fragment() {
	float shrink_width = 2.0 / width;
	float shrink_height = 2.0 / height;
	float dist = distance(vec2(UV.x * shrink_width, UV.y * shrink_height), vec2(0.5 * shrink_width, 0.5 * shrink_height));
	COLOR.a = 1.0 - floor(dist);
}