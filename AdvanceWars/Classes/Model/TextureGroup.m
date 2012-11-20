//
//  TextureGroup.m
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/16/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import "TextureGroup.h"

@interface TextureGroup()

@property (nonatomic, assign) GLint texture0;
@property (nonatomic, assign) GLint texture1;
@property (nonatomic, assign) GLint texture2;
@end

@implementation TextureGroup

- (void)addTexture:(GLint)newTexture
{
    if (self.texture0 < 0) {
        self.texture0 = newTexture;
        return;
    }
    if (self.texture1 < 0) {
        self.texture1 = newTexture;
        return;
    }
    if (self.texture2 < 0) {
        self.texture2 = newTexture;
        return;
    }
    
    NSLog(@"To Many Textures!!!!");

}
- (void)bind
{
    if (self.texture0 > 0) {
        glBindTexture(GL_TEXTURE0, self.texture0);
    }
    if (self.texture1 > 0) {
        glBindTexture(GL_TEXTURE1, self.texture1);
    }
    if (self.texture2 > 0) {
        glBindTexture(GL_TEXTURE2, self.texture2);
    }

}

- (NSString*)identifer
{
    return self.identifer;
}
@end
