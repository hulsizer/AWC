//
//  ShaderManager.m
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/12/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import "ShaderManager.h"
#import "Shader.h"
#import <GLKit/GLKit.h>
@interface ShaderManager()

@property (nonatomic, strong) NSMutableDictionary *previousLoadedShaders;
@property (nonatomic, strong) NSMutableDictionary *previousLoadedFragmentShaders;
@property (nonatomic, strong) NSMutableDictionary *previousLoadedVertexShaders;
@end

@implementation ShaderManager

+ (ShaderManager*)sharedInstance
{
	static dispatch_once_t pred = 0; 
    __strong static id _sharedObject = nil; 
    dispatch_once(&pred, ^{ 
		_sharedObject = [[self alloc] init]; 
    }); 
    return _sharedObject;
}

- (GLuint)loadShader:(NSString*)fileName shaderName:(NSString*)keyName type:(GLenum)type
{
	GLuint shader;
	
	if (![self.previousLoadedShaders objectForKey:keyName]) {
        NSString *shaderPathname;
        // Create and compile vertex shader.
        shaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
        if (![self compileShader:&shader type:type file:shaderPathname]) {
            NSLog(@"Failed to compile vertex shader");
            return NO;
        }
    }else{
		shader = [[self.previousLoadedShaders objectForKey:keyName] unsignedIntValue];
    }

	return shader;
}

- (GLuint)loadShaders:(NSString*)vertShaderName fragment:(NSString*)fragShaderName forName:(NSString*)shaderName
{
    GLuint vertShader, fragShader;
       
    if (![self.previousLoadedShaders objectForKey:vertShaderName]) {
        NSString *vertShaderPathname;
        // Create and compile vertex shader.
        vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
        if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
            NSLog(@"Failed to compile vertex shader");
            return NO;
        }
		[self.previousLoadedVertexShaders setObject:[NSNumber numberWithUnsignedInt:vertShader] forKey:vertShaderName];
    }else{
        vertShader = [[self.previousLoadedShaders objectForKey:vertShaderName] unsignedIntValue];
    }
    
    
    if (![self.previousLoadedShaders objectForKey:fragShaderName]) {
        NSString *fragShaderPathname;
        // Create and compile vertex shader.
        // Create and compile fragment shader.
        fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
        if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
            NSLog(@"Failed to compile fragment shader");
            return NO;
        }
		[self.previousLoadedFragmentShaders setObject:[NSNumber numberWithUnsignedInt:fragShader] forKey:fragShaderName];
    }else{
        fragShader = [[self.previousLoadedShaders objectForKey:fragShaderName] unsignedIntValue];
    }

    // Create shader program.
    GLuint program = glCreateProgram();
        
    // Attach vertex shader to program.
    glAttachShader(program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(program, GLKVertexAttribPosition, "position");
    glBindAttribLocation(program, GLKVertexAttribNormal, "normal");
    
    // Link program.
    if (![self linkProgram:program]) {
        NSLog(@"Failed to link program: %d", program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (program) {
            glDeleteProgram(program);
            program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    //uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(program, "modelViewProjectionMatrix");
    //uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(program, "normalMatrix");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(program, fragShader);
        glDeleteShader(fragShader);
    }
    
	[self.previousLoadedShaders setObject:[NSNumber numberWithUnsignedInt:program] forKey:shaderName];
    return program;
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

- (Shader*)programForKey:(NSString*)key
{
    return [Shader new];
}

@end
