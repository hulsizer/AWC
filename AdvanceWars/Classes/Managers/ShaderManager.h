//
//  ShaderManager.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/12/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Shader;
@interface ShaderManager : NSObject

+ (ShaderManager*)sharedInstance;
- (GLuint)loadShaders:(NSString*)vertShaderName fragment:(NSString*)fragShaderName forName:(NSString*)shaderName;

- (GLuint)loadShader:(NSString*)fileName shaderName:(NSString*)keyName type:(GLenum)type;

- (Shader*)programForKey:(NSString*)key;
@end
