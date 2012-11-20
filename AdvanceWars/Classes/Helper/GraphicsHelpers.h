//
//  GraphicsHelpers.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/17/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@interface GraphicsHelpers : NSObject
+ (GLKMatrix4)CMOrtho2D:(GLfloat)left right:(GLfloat)right top:(GLfloat)top bottom:(GLfloat)bottom far:(GLfloat)far near:(GLfloat)near;
@end
