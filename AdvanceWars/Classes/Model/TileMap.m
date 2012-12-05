//
//  TileMap.m
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 12/4/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import "TileMap.h"
#import "Tile.h"

@interface TileMap ()

@property (nonatomic, strong) NSMutableArray *tiles;

@end


@implementation TileMap

- (void)addTile:(Tile*)tile
{
    [self.tiles addObject:tile];
}
@end
