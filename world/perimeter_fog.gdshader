shader_type spatial;
render_mode unshaded, cull_disabled, blend_mix, depth_draw_never;

uniform vec4 fog_color : source_color = vec4(0.49, 0.55, 0.61, 1.0);
uniform float base_alpha : hint_range(0.0, 1.0) = 0.35;
uniform float scroll_speed = 0.03;
uniform float noise_scale = 8.0;

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float value_noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	return mix(
		mix(hash(i), hash(i + vec2(1.0, 0.0)), f.x),
		mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), f.x),
		f.y
	);
}

void fragment() {
	vec2 uv = UV * vec2(noise_scale * 4.0, noise_scale * 0.5);
	float n1 = value_noise(uv + vec2(TIME * scroll_speed, TIME * scroll_speed * 0.4));
	float n2 = value_noise(uv * 2.1 - vec2(TIME * scroll_speed * 0.7, 0.0));
	float wisp = mix(n1, n2, 0.45);
	float height_fade = smoothstep(1.0, 0.25, UV.y);

	ALBEDO = fog_color.rgb;
	ALPHA = clamp((base_alpha + (wisp - 0.5) * 0.35) * height_fade, 0.0, 1.0);
}
