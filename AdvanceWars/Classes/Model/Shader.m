//
//  Shader.m
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/12/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import "Shader.h"

@implementation Shader

// Uniform index.
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum
{
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
    NUM_ATTRIBUTES
};

GLint uniforms[NUM_UNIFORMS];

- (void)setUp
{
    //uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(self.program, "modelViewProjectionMatrix");
    //uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(self.program, "normalMatrix");
}
- (void)bind
{
    // Render the object again with ES2
    glUseProgram(self.program);
    
}

- (void)unbind
{
    glUseProgram(0);
}

- (NSString*)identifer
{
    return self.identifer;
}
@end
