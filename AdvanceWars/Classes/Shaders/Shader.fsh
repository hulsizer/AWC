//
//  Shader.fsh
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/8/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
