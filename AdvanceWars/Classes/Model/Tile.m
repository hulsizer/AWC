//
//  Tile.m
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/17/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import "Tile.h"
#import "PositionComponent.h"
#import "DrawableComponent.h"
@implementation Tile

- (id)init
{
    self = [super init];
    if (self) {
        _positionComponent = [[PositionComponent alloc] init];
        _drawingComponent = [[DrawableComponent alloc] init];
        _drawingComponent.position = _positionComponent;
    }
    return self;
}

- (id)initWithPoint:(CGPoint)point
{
    self = [super init];
    if (self) {
        _positionComponent = [[PositionComponent alloc] init];
        _positionComponent.point = point;
        _drawingComponent = [[DrawableComponent alloc] init];
        _drawingComponent.position = _positionComponent;
    }
    return self;
}

@end
