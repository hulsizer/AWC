//
//  DrawableComonent.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/11/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import "Component.h"
#import "Scene.h"
#import "SmartVBO.h"

@class PositionComponent;
@class TextureGroup;
@class Shader;
@class CMEffect;
@interface DrawableComponent : Component

@property (nonatomic, strong) CMEffect *effect;
@property (nonatomic, strong) NSString *texture;
@property (nonatomic, strong) PositionComponent *position;
@property (nonatomic, strong) SmartVBO * vboVerts;
@property (nonatomic, strong) SmartVBO * vboUVS;
@property (nonatomic, strong) SmartVBO * vboColors;
@property (nonatomic, assign) GLuint vao;

- (void)draw:(GLKMatrix4) currentMatrix mode:(enum DrawMode) mode;
@end
