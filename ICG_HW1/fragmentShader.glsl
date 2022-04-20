#extension GL_OES_standard_derivatives: enable
precision mediump float;

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
    vec3 final_color = vec3(0.0,0.0,0.0);

    if(shadeMode == 1.0)
        gl_FragColor = fragcolor;
    if(shadeMode == 2.0){
        vec3 V = -normalize(mvVertex);
        vec3 N = normalize(nmInterp);
        vec3 L1 = normalize(light1 - mvVertex);
        vec3 H1 = normalize(L1+V);
        vec3 L2 = normalize(light2 - mvVertex);
        vec3 H2 = normalize(L2+V);
        vec3 L3 = normalize(light3 - mvVertex);
        vec3 H3 = normalize(L3+V);

        vec3 ambient = lightcolor1 * ka * frontColor +
                        lightcolor2 * ka * frontColor +
                        lightcolor3 * ka * frontColor;

        float cos1 = max(dot(L1,N),0.0);
        float cos2 = max(dot(L2,N),0.0);
        float cos3 = max(dot(L3,N),0.0);
        vec3 diffuse = lightcolor1 * kd * frontColor * cos1 +
                        lightcolor2 * kd * frontColor * cos2 +
                        lightcolor3 * kd * frontColor * cos3;

        float cosAlpha1 = max(dot(N,H1),0.0);
        float cosAlpha2 = max(dot(N,H2),0.0);
        float cosAlpha3 = max(dot(N,H3),0.0);
        vec3 specular = lightcolor1 * ks * pow(cosAlpha1,20.0) +
                        lightcolor2 * ks * pow(cosAlpha2,20.0) +
                        lightcolor3 * ks * pow(cosAlpha3,20.0);

        final_color = ambient + diffuse + specular;
        gl_FragColor = vec4(final_color, 1.0);
    }
    if(shadeMode == 3.0){
        vec3 dx = dFdx(mvVertex);
        vec3 dy = dFdy(mvVertex);
        vec3 V = -normalize(mvVertex);
        vec3 N = normalize(cross(dx, dy));
        vec3 L1 = normalize(light1 - mvVertex);
        vec3 H1 = normalize(L1+V);
        vec3 L2 = normalize(light2 - mvVertex);
        vec3 H2 = normalize(L2+V);
        vec3 L3 = normalize(light3 - mvVertex);
        vec3 H3 = normalize(L3+V);

        vec3 ambient = lightcolor1 * ka * frontColor +
                        lightcolor2 * ka * frontColor +
                        lightcolor3 * ka * frontColor;

        float cos1 = max(dot(L1,N),0.0);
        float cos2 = max(dot(L2,N),0.0);
        float cos3 = max(dot(L3,N),0.0);
        vec3 diffuse = lightcolor1 * kd * frontColor * cos1 +
                        lightcolor2 * kd * frontColor * cos2 +
                        lightcolor3 * kd * frontColor * cos3;

        float cosAlpha1 = max(dot(N,H1),0.0);
        float cosAlpha2 = max(dot(N,H2),0.0);
        float cosAlpha3 = max(dot(N,H3),0.0);
        vec3 specular = lightcolor1 * ks * pow(cosAlpha1,20.0) +
                        lightcolor2 * ks * pow(cosAlpha2,20.0) +
                        lightcolor3 * ks * pow(cosAlpha3,20.0);

        final_color = ambient + diffuse + specular;
        gl_FragColor = vec4(final_color, 1.0);
    }
    if(shadeMode == 4.0){
        vec3 V = -normalize(mvVertex);
        vec3 N = normalize(nmInterp);
        vec3 L1 = normalize(light1 - mvVertex);
        vec3 H1 = normalize(L1+V);
        vec3 L2 = normalize(light2 - mvVertex);
        vec3 H2 = normalize(L2+V);
        vec3 L3 = normalize(light3 - mvVertex);
        vec3 H3 = normalize(L3+V);

        vec3 ambient = lightcolor1 * ka * frontColor +
                        lightcolor2 * ka * frontColor +
                        lightcolor3 * ka * frontColor;

        float cos1 = max(dot(L1,N),0.0);
        float cos2 = max(dot(L2,N),0.0);
        float cos3 = max(dot(L3,N),0.0);
        if(cos1 >= 0.75)
            cos1 = 0.75;
        else if(cos1 >= 0.5)
            cos1 = 0.5;
        else if(cos1 >= 0.25)
            cos1 = 0.25;
        else
            cos1 = 0.0;
        if(cos2 >= 0.75)
            cos2 = 0.75;
        else if(cos2 >= 0.5)
            cos2 = 0.5;
        else if(cos2 >= 0.25)
            cos2 = 0.25;
        else
            cos2 = 0.0;
        if(cos3 >= 0.75)
            cos3 = 0.75;
        else if(cos3 >= 0.5)
            cos3 = 0.5;
        else if(cos3 >= 0.25)
            cos3 = 0.25;
        else
            cos3 = 0.0;
        vec3 diffuse = lightcolor1 * kd * frontColor * cos1 +
                        lightcolor2 * kd * frontColor * cos2 +
                        lightcolor3 * kd * frontColor * cos3;

        float cosAlpha1 = pow(max(dot(N,H1),0.0), 20.0);
        float cosAlpha2 = pow(max(dot(N,H2),0.0), 20.0);
        float cosAlpha3 = pow(max(dot(N,H3),0.0), 20.0);
        if(cosAlpha1 >= 0.67)
            cosAlpha1 = 0.67;
        else if(cosAlpha1 >= 0.33)
            cosAlpha1 = 0.33;
        else
            cosAlpha1 = 0.0;
        if(cosAlpha2 >= 0.67)
            cosAlpha2 = 0.67;
        else if(cosAlpha2 >= 0.33)
            cosAlpha2 = 0.33;
        else
            cosAlpha2 = 0.0;
        if(cosAlpha3 >= 0.67)
            cosAlpha3 = 0.67;
        else if(cosAlpha3 >= 0.33)
            cosAlpha3 = 0.33;
        else
            cosAlpha3 = 0.0;
        vec3 specular = lightcolor1 * ks * cosAlpha1 +
                        lightcolor2 * ks * cosAlpha2 +
                        lightcolor3 * ks * cosAlpha3;

        final_color = ambient + diffuse + specular;
        gl_FragColor = vec4(final_color, 1.0);
    }
}
