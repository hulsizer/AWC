//
//  TextureManager.m
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/16/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import "TextureManager.h"
#import "TextureGroup.h"
@implementation TextureManager

- (TextureGroup*)texturesForKey:(NSString*)key
{
    return [TextureGroup new];
}
@end
