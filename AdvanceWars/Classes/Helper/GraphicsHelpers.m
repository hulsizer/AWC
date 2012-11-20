//
//  GraphicsHelpers.m
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/17/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import "GraphicsHelpers.h"

@implementation GraphicsHelpers

+ (GLKMatrix4)CMOrtho2D:(GLfloat)left right:(GLfloat)right top:(GLfloat)top bottom:(GLfloat)bottom far:(GLfloat)far near:(GLfloat)near
{
    return GLKMatrix4Make((2/(right-left)), 0, 0, -(right+left)/(right-left),
                          0, 2/(top-bottom), 0, -(top+bottom)/(top-bottom),
                          0, 0, -2/(far-near), -(far+near)/(far-near),
                          0, 0, 0, 1);
}
@end
