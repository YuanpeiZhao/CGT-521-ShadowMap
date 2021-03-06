#version 400
uniform sampler2DShadow shadowmap;

uniform int pass;

out vec4 fragcolor;           
in vec4 shadow_coord;

uniform bool use4x4 = false;
uniform bool displayLit4color = false;
uniform float softness = 1.5f;
      
void main(void)
{   

	if(pass == 1) // render depth to shadowmap from light point of view
	{
		fragcolor = vec4(1.0-gl_FragCoord.z*gl_FragCoord.w); //compute a color for us to visualize the shadow map in rendermode = 2
	}
	else if(pass == 2) 
	{
		
		//float z = texture(shadowmap, shadow_coord.xy/shadow_coord.w).r; // light-space depth in the shadowmap
		//float r = shadow_coord.z / shadow_coord.w; // light-space depth of this fragment
		//float lit = float(r <= z); // if ref is closer than z then the fragment is lit
		
		float lit = textureProj(shadowmap, shadow_coord);
		vec4 lit4;

		if(use4x4){
			
			float w = softness/textureSize(shadowmap, 0).x;
			lit4[0] = textureProj(shadowmap, shadow_coord+vec4(-w, -w, 0.0, 0.0));
			lit4[1] = textureProj(shadowmap, shadow_coord+vec4(+w, -w, 0.0, 0.0));
			lit4[2] = textureProj(shadowmap, shadow_coord+vec4(-w, +w, 0.0, 0.0));
			lit4[3] = textureProj(shadowmap, shadow_coord+vec4(+w, +w, 0.0, 0.0));
			lit = dot(lit4, vec4(0.25, 0.25, 0.25, 0.25));
	
		}
		
		fragcolor  = vec4(lit);
		if(displayLit4color) fragcolor = lit4;
	}
	
}

