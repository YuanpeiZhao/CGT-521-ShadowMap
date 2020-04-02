#version 400
uniform sampler2D shadowmap;

uniform int pass;

out vec4 fragcolor;           
in vec4 shadow_coord;
      
void main(void)
{   

	if(pass == 1) // render depth to shadowmap from light point of view
	{
		fragcolor = vec4(1.0-gl_FragCoord.z*gl_FragCoord.w); //compute a color for us to visualize the shadow map in rendermode = 2
	}
	else if(pass == 2) 
	{
		
		float z = texture(shadowmap, shadow_coord.xy/shadow_coord.w).r; // light-space depth in the shadowmap
		float r = shadow_coord.z / shadow_coord.w; // light-space depth of this fragment
		float lit = float(r <= z); // if ref is closer than z then the fragment is lit

		fragcolor  = vec4(lit);
	}
	
}

