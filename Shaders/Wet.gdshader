shader_type canvas_item;

uniform sampler2D replacement_image: source_color;

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);
	vec4 replacement_color = texture(replacement_image, UV);
    if (replacement_color.a > 0.0 && original_color.a > 0.0) {
        COLOR = texture(replacement_image, UV);
    } else {
        COLOR = original_color;
    }
}
