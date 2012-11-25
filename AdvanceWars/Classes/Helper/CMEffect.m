//
//  CMEffect.m
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/14/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import "CMEffect.h"
#import "ShaderManager.h"

/////////////////////////////////////////////////////////////////
// GLSL program uniform indices.
typedef enum
{
    CMModelviewMatrix,
    CMMVPMatrix,
    CMNormalMatrix,
    CMTex0Matrix,
    CMTex1Matrix,
    CMTex2Matrix,
    CMSamplers,
    CMTex0Enabled,
    CMTex1Enabled,
    CMTex2Enabled,
    CMGlobalAmbient,
    CMLight0Pos,
    CMLight0Direction,
    CMLight0Diffuse,
    CMLight0Cutoff,
    CMLight0Exponent,
    CMLight1Pos,
    CMLight1Direction,
    CMLight1Diffuse,
    CMLight1Cutoff,
    CMLight1Exponent,
    CMLight2Pos,
    CMLight2Diffuse,
    CMConstantColorEnabled,
    CMConstantColor,
    CMNumUniforms
} CMUniforms;

@interface CMEffect()
{
    GLint _uniforms[CMNumUniforms];
}

@property (nonatomic, assign) GLuint program;
@property (nonatomic, assign) GLKVector3 light0EyePosition;
@property (nonatomic, assign) GLKVector3 light0EyeDirection;
@property (nonatomic, assign) GLKVector3 light1EyePosition;
@property (nonatomic, assign) GLKVector3 light1EyeDirection;
@property (nonatomic, assign) GLKVector3 light2EyePosition;

@property (nonatomic, assign) GLuint constantColorEnabled;
@end
@implementation CMEffect

/*(- (id)initWithVertShader:(GLuint) vertShader andFragShader:(GLuint)fragShader
 {
 self = [super init];
 if (self) {
 //_vertShader = vertShader;
 //_fragShader = fragShader;
 }
 return self;
 }*/

- (id)init
{
    if(nil != (self = [super init]))
    {
        _textureMatrix2d0 = GLKMatrix4Identity;
        _textureMatrix2d1 = GLKMatrix4Identity;
        self.texture2d0.enabled = GL_FALSE;
        self.texture2d1.enabled = GL_FALSE;
        self.material.ambientColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
        self.lightModelAmbientColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
        self.light0.enabled = GL_FALSE;
        self.light1.enabled = GL_FALSE;
        self.light2.enabled = GL_FALSE;
        self.constantColorEnabled = GL_TRUE;
        self.contantColor = GLKVector4Make(1, 0, 0, 1);
        self.transform = [[GLKEffectPropertyTransform alloc] init];
        self.transform.projectionMatrix = GLKMatrix4Identity;
        self.transform.modelviewMatrix = GLKMatrix4Identity;
    }
    
    return self;
}


- (id)initWithProgram:(GLuint) program
{
    self = [super init];
	if (self) {
		_program = program;
	}
	return self;
}

- (id)initWithVertShaderFile:(NSString*)vertShaderFile andFragShaderFile:(NSString*)fragShaderFile effectName:(NSString*)effectName
{
	self = [super init];
	if (self) {
		_program = [[ShaderManager sharedInstance] loadShaders:vertShaderFile fragment:fragShaderFile forName:effectName];
	}
	return self;
}

- (void)bindProgram
{
    if(0 == self.program)
    {
        [self loadShaders];
    }
    if(0 != self.program)
    {
        glUseProgram(_program);
    }
}
- (void)bindTextures
{
    // Bind all of the textures to their respective units
    glActiveTexture(GL_TEXTURE0);
    if(0 != self.texture2d0.name && self.texture2d0.enabled)
    {
        glBindTexture(GL_TEXTURE_2D, self.texture2d0.name);
    }
    else
    {
        glBindTexture(GL_TEXTURE_2D, 0);
    }
    
    glActiveTexture(GL_TEXTURE1);
    if(0 != self.texture2d1.name && self.texture2d1.enabled)
    {
        glBindTexture(GL_TEXTURE_2D, self.texture2d1.name);
    }
    else
    {
        glBindTexture(GL_TEXTURE_2D, 0);
    }
}
- (void)bindUniforms
{
    if(0 != self.program)
    {
        // Local storage for texture sampler IDs
        //const GLuint   samplerIDs[2] = {0, 1};
        
        // Pre-calculate the mvpMatrix
        GLKMatrix4 modelViewProjectionMatrix = GLKMatrix4Multiply(
                                                                  self.transform.projectionMatrix,
                                                                  self.transform.modelviewMatrix);
        
        // Standard matrices
        //glUniformMatrix4fv(_uniforms[CMModelviewMatrix], 1, 0,
        //                   self.transform.modelviewMatrix.m);
        glUniformMatrix4fv(_uniforms[CMMVPMatrix], 1, 0,
                           modelViewProjectionMatrix.m);
        
        glUniform4f(_uniforms[CMConstantColor], self.contantColor.x, self.contantColor.y, self.contantColor.z, self.contantColor.w);
        

    }
}
- (void)prepareToDraw
{
    [self bindProgram];
    [self bindTextures];
    [self bindUniforms];
    
    if(0 == self.program)
    {
        [self loadShaders];
    }
    
#ifdef DEBUG
    {  // Report any errors
        GLenum error = glGetError();
        if(GL_NO_ERROR != error)
        {
            NSLog(@"GL Error: 0x%x", error);
        }
    }
#endif
}

- (NSString*)identifer
{
    return @"Effect";
}

- (GLuint)loadShaders
{
    GLuint vertShader, fragShader;
    
    //if (![self.previousLoadedShaders objectForKey:vertShaderName]) {
    NSString *vertShaderPathname;
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"basic" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    //[self.previousLoadedVertexShaders setObject:[NSNumber numberWithUnsignedInt:vertShader] forKey:vertShaderName];
    //}else{
    //    vertShader = [[self.previousLoadedShaders objectForKey:vertShaderName] unsignedIntValue];
    // }
    
    
    //if (![self.previousLoadedShaders objectForKey:fragShaderName]) {
    NSString *fragShaderPathname;
    // Create and compile vertex shader.
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"basic" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    //[self.previousLoadedFragmentShaders setObject:[NSNumber numberWithUnsignedInt:fragShader] forKey:fragShaderName];
    //}else{
    //    fragShader = [[self.previousLoadedShaders objectForKey:fragShaderName] unsignedIntValue];
    //}
    
    // Create shader program.
    self.program = glCreateProgram();
    
    // Attach vertex shader to program.
    glAttachShader(self.program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(self.program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(self.program, GLKVertexAttribPosition, "a_position");
    glBindAttribLocation(self.program, GLKVertexAttribColor, "a_color");
    //glBindAttribLocation(program, GLKVertexAttribNormal, "a_normal");
    
    // Link program.
    if (![self linkProgram:self.program]) {
        NSLog(@"Failed to link program: %d", self.program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (self.program) {
            glDeleteProgram(self.program);
            self.program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    //uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(program, "modelViewProjectionMatrix");
    //uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(program, "normalMatrix");
    
    _uniforms[CMConstantColor] = glGetUniformLocation(_program, "u_constantColor");
    _uniforms[CMMVPMatrix] = glGetUniformLocation(_program, "u_mvpMatrix");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(self.program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(self.program, fragShader);
        glDeleteShader(fragShader);
    }
    
	//[self.previousLoadedShaders setObject:[NSNumber numberWithUnsignedInt:program] forKey:shaderName];
    return self.program;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (void)tearDown
{
    //glDeleteBuffers(1, &_vertexBuffer);
    //glDeleteVertexArraysOES(1, &_vertexArray);
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }

}

@end
