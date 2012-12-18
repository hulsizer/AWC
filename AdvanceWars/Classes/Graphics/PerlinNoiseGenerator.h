//
//  PerlinNoiseGenerator.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 12/14/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PERMUTATION_SIZE 256

@interface PerlinNoiseGenerator : NSObject
{
    int randomMap[PERMUTATION_SIZE];
}
- (double)smoothNoise:(double)x y:(double)y;
+ (GLuint)generateMapTile:(double)width height:(double)height;
+ (GLuint)generateMap:(double)width height:(double)height;
@end
