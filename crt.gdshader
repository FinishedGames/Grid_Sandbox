shader_type canvas_item;

void fragment() {
    // Get the UV coordinates of the current pixel
	vec2 uv = SCREEN_UV;
    // Calculate the size of a single pixel in UV coordinates
    vec2 pixel_size = vec2(1.0) / (FRAGCOORD.xy / SCREEN_UV);

    // Initialize color accumulator
    vec4 color_accumulator = vec4(0.0);

    // Loop through the 2x2 block of pixels
    for (float x = 0.0; x < 2.0; x++) {
        for (float y = 0.0; y < 2.0; y++) {
            // Calculate the UV for each pixel in the 2x2 block
            vec2 sample_uv = uv + vec2(x, y) * pixel_size;
            // Sample the texture color
            color_accumulator += texture(TEXTURE, sample_uv);
        }
    }

    // Average the colors
    vec4 average_color = color_accumulator / 4.0;

    // Set the output color
    COLOR = average_color;
}
