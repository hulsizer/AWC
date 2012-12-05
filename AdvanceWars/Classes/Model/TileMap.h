//
//  TileMap.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 12/4/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import "GameObject.h"
@class Tile;

@interface TileMap : GameObject

- (void)addTile:(Tile*)tile;
@end
