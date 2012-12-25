//
//  Entity.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 12/23/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EntityManager;

@interface Entity : NSObject

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) EntityManager *entityManager;

- (void) addComponent: (id) component;
- (BOOL) hasComponentNamed: (NSString*) componentName;
- (id) getComponentNamed: (NSString*) componentName;
- (void) removeComponentNamed: (NSString*) componentName;
@end
