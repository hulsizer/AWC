//
//  GraphicsRenderer.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/16/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DrawableComponent;

@interface GraphicsRenderer : NSObject

- (void)addDrawableComponent:(DrawableComponent*)component;
- (void)draw;
@end
