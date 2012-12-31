//
//  SubDrawableComponent.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 12/30/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import "DrawableComponent.h"

@interface SubDrawableComponent : DrawableComponent

@property (nonatomic, weak) DrawableComponent *parent;
@property (nonatomic, assign) NSInteger index;
@end
