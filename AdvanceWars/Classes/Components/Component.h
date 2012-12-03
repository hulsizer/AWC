//
//  Component.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/11/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    e_PHYSICS,
    e_GRAPHICS,
    e_CUSTOM,
    e_COUNT
}COMPONENT_TYPE;

@interface Component : NSObject
{
    COMPONENT_TYPE type;
    uint id;
}

- (void)update;

@property (nonatomic, readonly) uint id;
@property (nonatomic, readonly) COMPONENT_TYPE type;
@end
