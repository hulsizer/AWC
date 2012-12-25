//
//  AGLKTextureMatrix2PointLightShader.fsh
//  
//

/////////////////////////////////////////////////////////////////
// TEXTURE
/////////////////////////////////////////////////////////////////
#define MAX_TEXTURES    2
#define MAX_TEX_COORDS  2

uniform sampler2D u_texture;

varying lowp vec4 v_color;
varying lowp vec2 v_texture_coord;

void main()
{
	lowp vec4 outlineGreen = vec4(122.0/255.0, 179.0/255.0, 23.0/255.0,1.0);
    lowp vec4 blue = vec4( 179.0/255.0, 204.0/255.0, 87.0/255.0,1.0);// * texture2D(u_texture, v_texture_coord).a;
    lowp vec4 white = vec4( 236.0/255.0,240.0/255.0,129.0/255.0,1.0);// * texture2D(u_texture, v_texture_coord).a;
    //lowp vec2 final_color = v_color * texture2D(u_texture, v_texture_coord);
    lowp vec4 result = mix(blue,white,texture2D(u_texture, v_texture_coord).a);
    
	if (v_texture_coord.x > .98 || v_texture_coord.y > .98)// || v_texture_coord.x < .01 || v_texture_coord.y > .01)
	{
		result = outlineGreen;
	}
    gl_FragColor =  texture2D(u_texture, v_texture_coord);
}
