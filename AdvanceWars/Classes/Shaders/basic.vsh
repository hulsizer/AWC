//
//  AGLKTextureMatrix2PointLightShader.vsh
//  
//

/////////////////////////////////////////////////////////////////
// VERTEX ATTRIBUTES
/////////////////////////////////////////////////////////////////
attribute vec4 a_position;
attribute vec4 a_color;
//attribute vec3 a_normal;
attribute vec2 a_texCoord0;
attribute vec2 a_texCoord1;

/////////////////////////////////////////////////////////////////
// TEXTURE
/////////////////////////////////////////////////////////////////
#define MAX_TEXTURES    2
#define MAX_TEX_COORDS  2

uniform mat4 u_mvpMatrix;
uniform sampler2D u_texture;

varying lowp vec4 v_color;
varying lowp vec2 v_texture_coord;

void main()
{
    v_color = a_color;
    v_texture_coord = a_texCoord0;
	gl_Position = u_mvpMatrix * a_position;
}
