shader_type canvas_item;
uniform sampler2D mask;
uniform float ramp = 1.0;
//uniform float red_luminosity = 0.299;
//uniform float green_luminosity = 0.587;
//uniform float blue_luminosity = 0.114;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec4 vmask = texture(mask, UV);
//	float gs = color.r*red_luminosity + color.g*green_luminosity + color.b*blue_luminosity;
	color.a = clamp(vmask.a*color.a*ramp, 0.0, 1.0);
	COLOR = color;
}
