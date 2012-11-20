//
//  Shader.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/12/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shader : NSObject

@property (nonatomic, assign) GLuint vertShader;
@property (nonatomic, assign) GLuint fragShader;
@property (nonatomic, assign) GLuint program;
@property (nonatomic, assign) NSString *identifer;

- (void)setUp;
- (void)bind;
- (void)unbind;
- (NSString*)identifer;
@end
