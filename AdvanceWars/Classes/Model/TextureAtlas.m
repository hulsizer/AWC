//
//  TextureAtlas.m
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 12/3/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import "TextureAtlas.h"
#import "Texture.h"

@interface TextureAtlas()

@property (nonatomic, assign) GLuint tileWidth;
@property (nonatomic, assign) GLuint tileHeight;
@property (nonatomic, strong) Texture *texture;
@property (nonatomic, strong) NSMutableDictionary *textures;
@end

@implementation TextureAtlas
@synthesize gid = _gid;

- (id)initWithTextureName:(Texture*)texture Width:(GLuint)width height:(GLuint)height
{
    self = [super init];
    if (self) {
        self.texture = texture;
        self.tileWidth = width;
        self.tileHeight = height;
        self.textures = [[NSMutableDictionary alloc] init];
        [self createTextureMap];
        
        _gid = globalObjectID++;
    }
    return self;
}

- (void)createTextureMap
{
    int textureIDS = 0;
    for (int x = 0; x < self.texture.width; x+=self.tileWidth) {
        for (int y = 0; y < self.texture.height; y+=self.tileHeight) {
            //create UVS
            CGPoint upperLeft = CGPointMake(x/self.texture.width, y/self.texture.height);
            CGPoint upperRight = CGPointMake((x+self.tileWidth)/self.texture.width, y/self.texture.height);
            CGPoint lowerLeft = CGPointMake(x/self.texture.width, (y+self.tileHeight)/self.texture.height);
            CGPoint lowerRight = CGPointMake((x+self.tileWidth)/self.texture.width, (y+self.tileHeight)/self.texture.height);
            
            GLfloat *texturCoords = malloc(sizeof(GLfloat)*12);
            texturCoords[0] = upperLeft.x;
            texturCoords[1] = upperLeft.y;
            texturCoords[2] = upperRight.x;
            texturCoords[3] = upperRight.y;
            texturCoords[4] = lowerRight.x;
            texturCoords[5] = lowerRight.y;
            texturCoords[6] = lowerRight.x;
            texturCoords[7] = lowerRight.y;
            texturCoords[8] = lowerLeft.x;
            texturCoords[9] = lowerLeft.y;
            texturCoords[10] = upperLeft.x;
            texturCoords[11] = upperLeft.y;
            
            NSData *textureData = [NSData dataWithBytes:texturCoords length:12];
            [self.textures setObject:textureData forKey:[NSNumber numberWithInt:textureIDS]];
            textureIDS++;
        }
    }
}

- (const GLvoid*)getTextureForID:(int)textureId
{
    
    return [[self.textures objectForKey:[NSNumber numberWithInt:textureId]] bytes];
}


@end
