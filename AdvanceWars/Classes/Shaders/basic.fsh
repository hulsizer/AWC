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
    //lowp vec2 final_color = v_color * texture2D(u_texture, v_texture_coord);
    gl_FragColor = mix(
                     v_color,
                     texture2D(u_texture, v_texture_coord),
                     0.5
                  );
}
