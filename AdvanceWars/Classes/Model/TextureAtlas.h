//
//  TextureAtlas.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 12/3/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Texture;
@interface TextureAtlas : NSObject

- (id)initWithTextureName:(Texture*)texture Width:(GLuint)width height:(GLuint)height;
- (const GLvoid*)getTextureForID:(int)textureId;
@end
