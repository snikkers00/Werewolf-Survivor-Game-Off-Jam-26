shader_type spatial;

uniform sampler2D base_tex : source_color, filter_nearest, repeat_enable;
uniform vec4 base_color : source_color = vec4(0.047, 0.267, 0.004, 1.0);
uniform float base_tex_scale = 2.0;

uniform sampler2D noise : filter_nearest, repeat_enable;
uniform sampler2D noise2 : filter_nearest, repeat_enable;
varying vec2 world_pos;
uniform float scale : hint_range(0.0, 10000.0, 20.0) = 500.0;
uniform float color_modifier2 : hint_range(0.0, 5.0, 0.01) = 0.9;
uniform float color_modifier3 : hint_range(0.0, 5.0, 0.01) = 0.8;
uniform float color_modifier4 : hint_range(0.0, 5.0, 0.01) = 0.85;

uniform float amount_covered : hint_range(0.0, 1.0, 0.01) = 0.5;
uniform float alpha2 : hint_range(0.0, 1.0, 0.01) = 1.0;
uniform float alpha3 : hint_range(0.0, 1.0, 0.01) = 1.0;
uniform float alpha4 : hint_range(0.0, 1.0, 0.01) = 1.0;
uniform bool col_alph2 = false;
uniform bool col_alph3 = false;
uniform bool col_alph4 = false;

uniform sampler2D grass_tex : repeat_enable, filter_nearest;
uniform float grass_amount = 16.0;
uniform float col_grass_mul : hint_range(0.0, 1.0, 0.01) = 0.97;
uniform float gr_mul_amount_added2 : hint_range(-1.0, 1.0, 0.01) = 0.05;
uniform float gr_mul_amount_added3 : hint_range(-1.0, 1.0, 0.01) = 0.05;
uniform float gr_mul_amount_added4 : hint_range(-1.0, 1.0, 0.01) = 0.04;

uniform sampler2D grass_tex2 : repeat_enable, filter_nearest;
uniform float grass_amount2 = 16.0;
uniform float col_grass_mul2 : hint_range(0.0, 1.0, 0.01) = 0.97;
uniform float gr_mul_amount_added22 : hint_range(-1.0, 1.0, 0.001) = 0.05;
uniform float gr_mul_amount_added32 : hint_range(-1.0, 1.0, 0.001) = 0.05;
uniform float gr_mul_amount_added42 : hint_range(-1.0, 1.0, 0.001) = 0.04;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xz;
}

void fragment() {
	vec4 noise_tex = texture(noise, world_pos / scale);
	vec4 noise_tex2 = texture(noise2, world_pos / scale);
	vec4 tex_tex = texture(base_tex, world_pos / base_tex_scale) * base_color;
	float AAC = 1.0 - amount_covered;

	float mult_gr = col_grass_mul;
	float mult_gr2 = col_grass_mul2;
	vec4 out_col = tex_tex;

	if (noise_tex.r <= AAC) {
		mult_gr += gr_mul_amount_added2;
		mult_gr2 += gr_mul_amount_added22;
		out_col = vec4(tex_tex.rgb * color_modifier2, col_alph2 ? alpha2 : noise_tex.a);
	} else if (noise_tex2.r >= AAC) {
		mult_gr += gr_mul_amount_added3;
		mult_gr2 += gr_mul_amount_added32;
		out_col = vec4(tex_tex.rgb * color_modifier3, col_alph3 ? alpha3 : noise_tex2.a);
	} else if (noise_tex2.r <= AAC) {
		mult_gr += gr_mul_amount_added4;
		mult_gr2 += gr_mul_amount_added42;
		out_col = vec4(tex_tex.rgb * color_modifier4, col_alph4 ? alpha4 : noise_tex2.a);
	}

	vec4 special_grass_tex = texture(grass_tex, world_pos / grass_amount);
	vec4 special_grass_tex2 = texture(grass_tex2, world_pos / grass_amount2);
	if (special_grass_tex.rgb == vec3(1.0)) {
		out_col *= vec4(mult_gr);
	}
	if (special_grass_tex2.rgb == vec3(1.0)) {
		out_col *= vec4(mult_gr2);
	}

	ALBEDO = out_col.rgb;
}
