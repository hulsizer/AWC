//
//  GameDirector.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/11/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
@class ScriptRunner;
@class Scene;
@class Component;


@interface GameDirector : GLKViewController

- (void)registerObject:(Component*)object;
- (void)deregisterObject:(Component*)object;

@property (nonatomic, strong) ScriptRunner *scriptRunner;
@property (nonatomic, strong) NSMutableDictionary *components;
@property (nonatomic, strong) Scene *scene;
@end
