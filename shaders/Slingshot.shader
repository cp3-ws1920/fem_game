shader_type canvas_item;

void fragment() {
	vec2 adj_uv = SCREEN_UV / SCREEN_PIXEL_SIZE * TEXTURE_PIXEL_SIZE;
	adj_uv.y *= -1.0;
	COLOR = texture(TEXTURE, adj_uv);
}