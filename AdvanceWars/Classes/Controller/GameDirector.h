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
@class EntityManager;


@interface GameDirector : GLKViewController

- (void)registerObject:(Component*)object;
- (void)deregisterObject:(Component*)object;

- (NSObject*)getObject:(int)gid;

@property (nonatomic, strong) ScriptRunner *scriptRunner;
@property (nonatomic, strong) NSMutableDictionary *components;
@property (nonatomic, strong) Scene *scene;
@property (nonatomic, strong) EntityManager *entityManager;
@end
