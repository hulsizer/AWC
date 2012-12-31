//
//  TextureManager.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/16/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TextureGroup;
@class Texture;
@interface TextureManager : NSObject
+ (TextureManager*)sharedInstance;
- (void)loadTextureWithName:(NSString*)name;
- (Texture*)textureForName:(NSString*)name;
@property (nonatomic, strong) NSMutableDictionary *textures;
@end
