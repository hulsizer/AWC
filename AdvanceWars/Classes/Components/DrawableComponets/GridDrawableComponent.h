//
//  TileDrawableComponent.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/12/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import "DrawableComponent.h"

@class Shader;

@interface GridDrawableComponent : DrawableComponent

- (void)rebind;

- (id)initWithGridColumns:(GLuint)columns gridRows:(GLuint)rows;
@end
