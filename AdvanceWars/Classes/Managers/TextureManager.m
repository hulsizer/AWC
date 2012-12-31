//
//  TextureManager.m
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/16/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import "TextureManager.h"
#import "TextureGroup.h"
#import "Texture.h"
@implementation TextureManager

- (id)init
{
    self = [super init];
    if (self) {
        self.textures = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (TextureGroup*)texturesForKey:(NSString*)key
{
    return [TextureGroup new];
}

- (void)loadTextureWithName:(NSString *)name
{
    Texture *texture = [[Texture alloc] initWithTextureName:name];
    [self.textures setObject:texture forKey:name];
}

- (Texture*)textureForName:(NSString *)name
{
    return [self.textures objectForKey:name];
}
+ (TextureManager*)sharedInstance
{
	static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
		_sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}
@end
