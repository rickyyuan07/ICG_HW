attribute vec3 aVertexPosition;
attribute vec3 aFrontColor;
attribute vec3 aVertexNormal;

uniform mat4 uMVMatrix;
uniform mat4 uPMatrix;
uniform mat4 uNMMatrix;
uniform int mode; // 1: gouraud, 2: phong, 3: flat, 4: cel
uniform vec3 k; // ambient, diffuse, specular intensities
uniform vec3 light_pos1;
uniform vec3 light_col1;
uniform vec3 light_pos2;
uniform vec3 light_col2;
uniform vec3 light_pos3;
uniform vec3 light_col3;

varying vec4 fragcolor;
varying vec3 nmInterp;
varying vec3 mvVertex;
varying vec3 frontColor;
varying float shadeMode; // 1: gouraud, 2: phong, 3: flat, 4: cel
varying float ka, kd, ks;
varying vec3 light1;
varying vec3 lightcolor1;
varying vec3 light2;
varying vec3 lightcolor2;
varying vec3 light3;
varying vec3 lightcolor3;

void main(void) {
    mat3 normalMatrix = mat3(uNMMatrix);

    light1 = light_pos1;
    lightcolor1 = light_col1;
    light2 = light_pos2;
    lightcolor2 = light_col2;
    light3 = light_pos3;
    lightcolor3 = light_col3;
    
    vec3 final_color = vec3(0.0,0.0,0.0);
    mvVertex = (uMVMatrix * vec4(aVertexPosition, 1.0)).xyz;
    nmInterp = normalMatrix * aVertexNormal;
    frontColor = aFrontColor;
    shadeMode = float(mode);
    ka = k[0]; // ambient
    kd = k[1]; // diffuse
    ks = k[2]; // specular

    // gouraud shading || flat shading
    if(mode == 1 || mode == 3){
        mat3 normalMVMatrix = mat3(uMVMatrix);
        vec3 mvNormal = normalMVMatrix * aVertexNormal;

        vec3 V = -normalize(mvVertex);
        vec3 N = normalize(mvNormal);
        vec3 L1 = normalize(light1 - mvVertex);
        vec3 H1 = normalize(L1+V);
        vec3 L2 = normalize(light2 - mvVertex);
        vec3 H2 = normalize(L2+V);
        vec3 L3 = normalize(light3 - mvVertex);
        vec3 H3 = normalize(L3+V);

        vec3 ambient = lightcolor1 * ka * aFrontColor +
                        lightcolor2 * ka * aFrontColor +
                        lightcolor3 * ka * aFrontColor;

        float cos1 = max(dot(L1,N),0.0);
        float cos2 = max(dot(L2,N),0.0);
        float cos3 = max(dot(L3,N),0.0);
        vec3 diffuse = lightcolor1 * kd * aFrontColor * cos1 +
                        lightcolor2 * kd * aFrontColor * cos2 +
                        lightcolor3 * kd * aFrontColor * cos3;

        float cosAlpha1 = max(dot(N,H1),0.0);
        float cosAlpha2 = max(dot(N,H2),0.0);
        float cosAlpha3 = max(dot(N,H3),0.0);
        vec3 specular = lightcolor1 * ks * pow(cosAlpha1,20.0) +
                        lightcolor2 * ks * pow(cosAlpha2,20.0) +
                        lightcolor3 * ks * pow(cosAlpha3,20.0);

        final_color = ambient + diffuse + specular;
    }

    fragcolor = vec4(final_color, 1.0);
    gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
}