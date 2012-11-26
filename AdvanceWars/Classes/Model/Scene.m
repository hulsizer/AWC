//
//  Scene.m
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/17/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import "Scene.h"
#import "CMEffect.h"

@implementation Scene

- (id)initWithProjection:(GLKMatrix4)projectionMatrix
{
    self = [super init];
    if (self) {
        self.projectionMatrix = projectionMatrix;
        self.cameraMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 1, 1, 0);
        self.cameraScaleMatrix = GLKMatrix4Identity;
        
        self.translation = CGPointMake(0, 0);
        self.scale = 1;
        self.objects = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)registerObject:(DrawableComponent*)object
{
    //Set up gloabal properties such as lights
    object.effect.transform.projectionMatrix = self.projectionMatrix;
    
    static int temp_id = 0;
    temp_id++;
    //add object to rendering tree
    [self.objects addObject:object];
    //[self.objects setObject:object forKey:[NSNumber numberWithInt:temp_id]];
    
}

- (void)deregisterObject:(DrawableComponent*)object
{
    //remove object from rendering tree
}

- (GLKMatrix4)getCamera
{
    GLKMatrix4 camera = GLKMatrix4Identity;
    camera = GLKMatrix4Translate(camera, self.translation.x, self.translation.y, 0);
    camera = GLKMatrix4Scale(camera, self.scale, self.scale, 0);
    
    return camera;
}
- (void)draw
{
    GLKMatrix4 camera = [self getCamera];
    //draw tree
    for (DrawableComponent *object in self.objects) {
        [object draw:camera];
    }
}
@end
