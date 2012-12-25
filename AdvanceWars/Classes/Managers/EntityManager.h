//
//  EntityManager.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 12/23/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Entity;
@class Component;

@interface EntityManager : NSObject

- (Entity*)newEntityWithName:(NSString*)name;
- (void)removeEntity:(Entity*)entity;
- (void)addEntity:(Entity*)entity;
- (Entity*)getEntityByIdentifier:(NSNumber*)identifier;
- (NSArray*) findEntitiesWithComponentNamed: (NSString*) componentName;

- (void) addComponent: (id) component toEntity: (Entity*) entity;
- (void) removeComponentNamed: (NSString*) componentName fromEntity: (Entity*) entity;
- (BOOL) doesEntity: (Entity*) entity haveComponentNamed: (NSString*) componentName;
- (id) getComponentNamed: (NSString*) componentName forEntity: (Entity*) entity;
- (NSArray*) getComponentsForEntity: (Entity*) entity;
@end
