shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform bool activate;

void fragment() {
	vec4 pixelColor = texture(screen_texture, UV);
	//float brightness = (pixelColor.r + pixelColor.g + pixelColor.b) / 3.0;
	//vec4 grayScale = vec4(pixelColor.r, pixelColor.r, pixelColor.r, pixelColor.a);
	if(activate){
		COLOR.rgb = pixelColor.brg;
	} else {
		COLOR.rgb = pixelColor.rgb;
	}

}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
