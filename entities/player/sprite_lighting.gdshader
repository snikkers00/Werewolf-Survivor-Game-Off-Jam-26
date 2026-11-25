shader_type spatial;
render_mode cull_disabled;

uniform sampler2D albedo_tex : source_color, filter_nearest;
uniform bool y_billboard = true;
uniform vec4 modulate : source_color = vec4(1.0);
uniform float unshaded : hint_range(0.0, 1.0) = 0.0;

void vertex() {
	if (y_billboard) {
		MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
			vec4(normalize(cross(vec3(0.0, 1.0, 0.0), MAIN_CAM_INV_VIEW_MATRIX[2].xyz)), 0.0),
			vec4(0.0, 1.0, 0.0, 0.0),
			vec4(normalize(cross(MAIN_CAM_INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0),
			MODEL_MATRIX[3]
		);
		MODELVIEW_MATRIX = MODELVIEW_MATRIX * mat4(
			vec4(length(MODEL_MATRIX[0].xyz), 0.0, 0.0, 0.0),
			vec4(0.0, length(MODEL_MATRIX[1].xyz), 0.0, 0.0),
			vec4(0.0, 0.0, length(MODEL_MATRIX[2].xyz), 0.0),
			vec4(0.0, 0.0, 0.0, 1.0)
		);
		MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	}
}

void fragment() {
	vec4 tex = texture(albedo_tex, UV);
	vec3 col = tex.rgb * modulate.rgb;
	ALBEDO = col * (1.0 - unshaded);
	EMISSION = col * unshaded;
	ALPHA = tex.a * modulate.a;
	ALPHA_SCISSOR_THRESHOLD = 0.5;
}

void light() {
	float ndotl = max(abs(dot(NORMAL, LIGHT)), 0.4);
	DIFFUSE_LIGHT += ndotl * ATTENUATION * LIGHT_COLOR / PI;
}
