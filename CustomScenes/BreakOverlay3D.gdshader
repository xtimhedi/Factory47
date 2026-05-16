shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx, unshaded;

uniform sampler2D albedo_texture : source_color, filter_nearest;
uniform float frame_index = 0.0;
uniform float total_frames = 4.0;

varying vec3 local_pos;
varying vec3 local_normal;

void vertex() {
	local_pos = VERTEX;
	local_normal = abs(NORMAL);
}

void fragment() {
	vec2 base_uv = vec2(0.0);
	
	if (local_normal.x > local_normal.y && local_normal.x > local_normal.z) {
		base_uv = local_pos.zy + 0.5;
	} else if (local_normal.y > local_normal.x && local_normal.y > local_normal.z) {
		base_uv = local_pos.xz + 0.5;
	} else {
		base_uv = local_pos.xy + 0.5;
	}
	
	base_uv.x = (base_uv.x + frame_index) / total_frames;
	
	vec4 final_color = texture(albedo_texture, base_uv);
	
	ALBEDO = final_color.rgb;
	ALPHA = final_color.a;
}
