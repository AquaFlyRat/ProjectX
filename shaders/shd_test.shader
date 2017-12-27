//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
//attribute vec3 in_Normal;                  // (x,y,z)     unused in this shader.	
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
}

//######################_==_YOYO_SHADER_MARKER_==_######################@~







uniform vec3 r1, g1, b1, o1;
uniform vec3 r2, g2, b2, o2;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    float t = v_vTexcoord.x * (1. - v_vTexcoord.x) *
              v_vTexcoord.y * (1. - v_vTexcoord.y) * 16.;
              
    vec3 rv = mix(r2,r1,t);
    vec3 gv = mix(g2,g1,t);
    vec3 bv = mix(b2,b1,t);
    vec3 ov = mix(o2,o1,t);
    
    gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragColor = vec4((gl_FragColor.r*bv) + (gl_FragColor.g * rv) + (gl_FragColor.b*gv) +ov, gl_FragColor.a);
}
