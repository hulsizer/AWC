//
//  Tile.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/17/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PositionComponent;
@class DrawableComponent;
@interface Tile : NSObject

- (id)initWithPoint:(CGPoint)point;
@property (nonatomic,strong) PositionComponent *positionComponent;
@property (nonatomic,strong) DrawableComponent *drawingComponent;
@end
