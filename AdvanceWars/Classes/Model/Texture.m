//
//  Texture.m
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 12/3/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import "Texture.h"

@interface Texture ()
@property (nonatomic, strong) NSString *textureName;
@property (nonatomic, assign) GLuint texID;

@end

@implementation Texture

- (id)initWithTextureName:(NSString*)textureName
{
    self = [super init];
    if (self) {
        self.textureName = textureName;
        
        [self loadTexture];
    }
    return self;
}

- (void)loadTexture
{
    glGenBuffers(1, &_texID);
    glBindTexture(GL_TEXTURE_2D, _texID);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    
    NSString *path = [[NSBundle mainBundle] pathForResource:self.textureName ofType:@"png"];
    NSData *texData = [[NSData alloc] initWithContentsOfFile:path];
    UIImage *image = [[UIImage alloc] initWithData:texData];
    if (image == nil)
        NSLog(@"Do real error checking here");
    
    self.width = CGImageGetWidth(image.CGImage);
    self.height = CGImageGetHeight(image.CGImage);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void *imageData = malloc( self.height * self.width * 4 );
    CGContextRef context = CGBitmapContextCreate( imageData, self.width, self.height, 8, 4 * self.width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
    CGColorSpaceRelease( colorSpace );
    CGContextClearRect( context, CGRectMake( 0, 0, self.width, self.height ) );
    CGContextTranslateCTM( context, 0, self.height - self.height );
    CGContextDrawImage( context, CGRectMake( 0, 0, self.width, self.height ), image.CGImage );
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, self.width, self.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    
    CGContextRelease(context);
    
    free(imageData);
}

- (void)bind
{
    glBindTexture(GL_TEXTURE_2D, self.texID);
}
@end
