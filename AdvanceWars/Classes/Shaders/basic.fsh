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
    lowp vec4 blue = vec4( 51.0/255.0, 150.0/255.0, 220.0/255.0,1.0);// * texture2D(u_texture, v_texture_coord).a;
    lowp vec4 white = vec4( 255.0/255.0,255.0/255.0,255.0/255.0,1.0);// * texture2D(u_texture, v_texture_coord).a;
    //lowp vec2 final_color = v_color * texture2D(u_texture, v_texture_coord);
    lowp vec4 result = mix(blue,white,texture2D(u_texture, v_texture_coord).a);
    
    gl_FragColor =  result;
}
