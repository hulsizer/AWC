//
//  CMEffect.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/14/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class Texture;
@interface CMEffect : NSObject

@property (nonatomic, strong) GLKEffectPropertyTransform *transform;
@property (nonatomic, assign) NSString *identifer;
@property (assign) GLKVector4 light0Position;
@property (assign) GLKVector3 light0SpotDirection;
@property (assign) GLKVector4 light1Position;
@property (assign) GLKVector3 light1SpotDirection;
@property (assign) GLKVector4 light2Position;
@property (nonatomic, assign) GLKMatrix4 textureMatrix2d0;
@property (nonatomic, assign) GLKMatrix4 textureMatrix2d1;
@property (nonatomic, readonly) GLKEffectPropertyLight *light0, *light1, *light2;
@property (nonatomic, weak) Texture *texture2d0, *texture2d1;
@property (nonatomic, assign) GLKVector4 lightModelAmbientColor;
@property (nonatomic, readonly) GLKEffectPropertyMaterial *material;
@property (nonatomic, strong) NSString* vertFileName;
@property (nonatomic, strong) NSString*fragFileName;
@property (nonatomic, assign) GLKVector4 contantColor;
- (void)prepareToDraw;
- (void)bindProgram;
- (void)bindTextures;
- (void)bindUniforms;
- (NSString*)identifer;

- (void)tearDown;
@end
