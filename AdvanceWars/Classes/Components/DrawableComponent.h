//
//  DrawableComonent.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/11/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import "Component.h"
@class PositionComponent;
@class TextureGroup;
@class Shader;
@class CMEffect;
@interface DrawableComponent : Component

@property (nonatomic, strong) CMEffect *effect;
@property (nonatomic, strong) PositionComponent *position;

- (void)draw:(GLKMatrix4) currentMatrix;
@end
