//
//  Level.m
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/11/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import "Level.h"
#import "ScriptRunner.h"
#import "DrawableComponent.h"
#import "PositionComponent.h"
@interface Level()


@end

@implementation Level

- (id)initWithLuaFile:(NSString*)fileName luaState:(lua_State *)L
{
    self = [super init];
    if (self)
    {
        self.scriptRunner = [[ScriptRunner alloc] initWithDirector:self andScript:fileName];
        
        self.components = [[NSMutableDictionary alloc] init];
        //[self.components setObject:[[NSMutableDictionary alloc] init] forKey:[NSNumber numberWithInt:e_PHYSICS]];
        //[self.components setObject:[[NSMutableDictionary alloc] init] forKey:[NSNumber numberWithInt:e_GRAPHICS]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)update
{
    //for (PositionComponent *component in [self.components objectForKey:[NSNumber numberWithInt:e_PHYSICS]]) {
    //    [component update];
    //}
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    
   // for (DrawableComponent *component in [self.components objectForKey:[NSNumber numberWithInt:e_GRAPHICS]]) {
    ///    [component update];
    //}
    
}

@end
