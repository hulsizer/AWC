//
//  EntityManager.m
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 12/23/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import "EntityManager.h"
#import "Entity.h"
#import "Component.h"

@interface EntityManager ()

@property (nonatomic, assign) u_int16_t nextID;
@property (nonatomic, strong) NSMutableDictionary *entities;
@property (nonatomic, strong) NSMutableDictionary *components;

@end

@implementation EntityManager

- (id) init {
	self = [super init];
	
	if (self) {
		self.nextID = 1;
		self.entities = [[NSMutableDictionary alloc] init];
		self.components = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

- (Entity*)newEntityWithName:(NSString*)name
{
    Entity *newEntity = [[Entity alloc] init];
    
    newEntity.identifier = [NSNumber numberWithInt:self.nextID++];
    newEntity.name = name;
    newEntity.entityManager = self;
    
    return newEntity;
}

- (void)addEntity:(Entity*)entity
{
    [self.entities setObject:entity forKey:entity.identifier];
}

- (Entity*)getEntityByIdentifier:(NSNumber*)identifier
{
    return [self.entities objectForKey:identifier];
}

- (void)removeEntity:(Entity*)entity
{
    for (NSString *key in self.components) {
        NSMutableDictionary* instances = [self.components objectForKey: key];
        [instances removeObjectForKey:entity.identifier];
    }
    
    [self.entities removeObjectForKey:entity.identifier];
}

- (NSArray*) findEntitiesWithComponentNamed: (NSString*) componentName
{
    NSMutableDictionary* componentDict = [self.components objectForKey: componentName];
	
	if (componentDict == nil) {
		return nil;
	}
	
	NSMutableArray* output = [[NSMutableArray alloc] init];
	for (NSNumber* identifier in [componentDict allKeys]) {
		[output addObject: [self.entities objectForKey: identifier]];
	}
	
	return output;}

- (void) addComponent: (id) component toEntity: (Entity*) entity
{
    // find the dictionary for the component
	NSString* componentName = NSStringFromClass([component class]);
	NSMutableDictionary* componentDict = [self.components objectForKey: componentName];
	
	// create the component dictionary if it doesn't exist
	if (componentDict == nil) {
		componentDict = [[NSMutableDictionary alloc] init];
		[self.components setObject: componentDict forKey: componentName];
	}
	
	[componentDict setObject: component forKey: entity.identifier];
}

- (void) removeComponentNamed: (NSString*) componentName fromEntity: (Entity*) entity
{
    // find the dictionary for the component
	NSMutableDictionary* componentDict = [self.components objectForKey: componentName];
    
    if (componentDict != nil) {
        [componentDict removeObjectForKey:entity.identifier];
    }
}

- (BOOL) doesEntity: (Entity*) entity haveComponentNamed: (NSString*) componentName
{
    return ([self getComponentNamed:componentName forEntity:entity] != nil);
}

- (id) getComponentNamed: (NSString*) componentName forEntity: (Entity*) entity
{
    // find the dictionary for the component
	NSMutableDictionary* componentDict = [self.components objectForKey: componentName];
    
    return [componentDict objectForKey:entity.identifier];
}

- (NSArray*) getComponentsForEntity: (Entity*) entity
{
    NSMutableArray* entityComponents = [[NSMutableArray alloc] init];
	
	// loop over all the component types
	for (NSString* key in self.components) {
		NSMutableDictionary* instances = [self.components objectForKey: key];
		
		// find the component of this type for this entity
		id component = [instances objectForKey: entity.identifier];
		
		// if the component exists, add it to the return
		if (component) {
			[entityComponents addObject: component];
		}
	}
	
	return entityComponents;
}

@end
