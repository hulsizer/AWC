//
//  PerlinNoiseGenerator.m
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 12/14/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import "PerlinNoiseGenerator.h"


static const char gradient[4][2] =
{
    { 0, 1}, { 1, 0},
    {0, -1}, {-1, 0}
};

double lerp_f(double x, double y, double frac)
{
    return (x*(1 - frac))+(y*frac);
}

double splineWeight(double x)
{
    double square = x * x;
    double cubic = square * x;
    return 3*square-2*cubic;
}

double dotProduct(double x0, double y0, double x1, double y1)
{
    return x0*x1 + y0*y1;
}

@implementation PerlinNoiseGenerator

- (int)getIndexForGradientAtX:(int)x y:(int)y
{
    return randomMap[(x+(randomMap[(y & 0xff)]) & 0xff)] & 0x3;
}

- (id) init {
    if ((self = [super init])) {
        for (unsigned int i = 0; i < PERMUTATION_SIZE; i++) {
            int test = rand() & 0xff;
            randomMap[i] = test;
        }
    }
    return self;
}

- (double)smoothNoise:(double)x y:(double)y
{
    //Variables for the four corners of a grid
    int x0 = (int)x;
    int y0 = (int)y;
    int x1 = (int)x+1;
    int y1 = (int)y+1;
    
    //Deltas from each corner to the position
    double deltaX0 = x-x0;
    double deltaY0 = y-y0;
    const double deltaX1 = x-x1;
    const double deltaY1 = y-y1;
    
    //random gradients for each corner on the grid
    //they are not really random when given an index it must return the same value
    //if given the same index at a later time
    const char *gradient0 = gradient[[self getIndexForGradientAtX:x0 y:y0]];
    const char *gradient1 = gradient[[self getIndexForGradientAtX:x1 y:y0]];
    const char *gradient2 = gradient[[self getIndexForGradientAtX:x0 y:y1]];
    const char *gradient3 = gradient[[self getIndexForGradientAtX:x1 y:y1]];
    
    //Dot product of the vectos
    double dot0 = dotProduct(deltaX0, deltaY0, gradient0[0], gradient0[1]);
    double dot1 = dotProduct(deltaX1, deltaY0, gradient1[0], gradient1[1]);
    double dot2 = dotProduct(deltaX0, deltaY1, gradient2[0], gradient2[1]);
    double dot3 = dotProduct(deltaX1, deltaY1, gradient3[0], gradient3[1]);
    
    //weight the deltas to give good fractions
    deltaX0 = splineWeight(deltaX0);
    deltaY0 = splineWeight(deltaY0);
    
    //interpolate the vectors to avg
    double interpolate0 = lerp_f(dot0, dot1, deltaX0);
    double interpolate1 = lerp_f(dot2, dot3, deltaX0);
    
    //return the avg
    return lerp_f(interpolate0, interpolate1, deltaY0);
}

- (double)perlinNoiseForX:(double)x y :(double)y
{
    double total = 0;
    double p = 0.35;
    double n = 5;
    
    for (int i = 0 ; i < n-1; i++) {
        double frequency = powf(2, i);
        double amplitude = powf(p, i);
        
        total += [self smoothNoise:(x*(frequency/80)) y:(y*(frequency/80))]*amplitude;
    }
    
    return total;
}

+ (GLuint)generateMapTile:(double)width height:(double)height
{
    PerlinNoiseGenerator *perlinGen = [[PerlinNoiseGenerator alloc] init];
    GLubyte *rgba = malloc(width*height*sizeof(GLubyte)*4);
    int index = 0;
    
    for(int y=0;y<height;y++)
    {//Loops to loop trough all the pixels
        for(int x=0;x<width;x++)
        {
            double getnoise =  (([perlinGen perlinNoiseForX:x y:y] * (width - x) * (height - y)) +
                                ([perlinGen perlinNoiseForX:x-width y:y] * (x) * (height - y)) +
                                ([perlinGen perlinNoiseForX:x-width y:y-height] * (x) * (y)) +
                                 ([perlinGen perlinNoiseForX:x y:y-height] * (width - x) * (y))) / (width*height);
            
            int color= (int)((getnoise*128.0)+128.0);//Convert to 0-256 values.
            if(color>255)
                color=255;
            if(color<0)
                color=0;
            
            
            //R
            rgba[index++] = color;
            //G
            rgba[index++] = color;
            //B
            rgba[index++] = color;
            
            rgba[index++] = color;
        }
    }

    GLuint spriteTexture;
    glGenTextures(1, &spriteTexture);
    glBindTexture(GL_TEXTURE_2D, spriteTexture);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, rgba);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST);

    const size_t BitsPerComponent = 8;
    const size_t BytesPerRow=((BitsPerComponent * width) / 8) * 4;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef gtx = CGBitmapContextCreate(&rgba[0], width, height, BitsPerComponent, BytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
    
    // create the image:
    CGImageRef toCGImage = CGBitmapContextCreateImage(gtx);
    UIImage * uiimage = [[UIImage alloc] initWithCGImage:toCGImage];
    
    NSData * png = UIImagePNGRepresentation(uiimage);
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"IMAGE2.png"]];
    [png writeToFile:databasePath atomically:YES];
    
    free(rgba);
    return spriteTexture;
}

+ (GLuint)generateMap:(double)width height:(double)height
{
    PerlinNoiseGenerator *perlinGen = [[PerlinNoiseGenerator alloc] init];
    GLubyte *rgba = malloc(width*height*sizeof(GLubyte)*4);
    int index = 0;
    
    for(int y=0;y<height;y++)
    {//Loops to loop trough all the pixels
        for(int x=0;x<width;x++)
        {
            double getnoise = [perlinGen perlinNoiseForX:x y:y];
            
            int color= (int)((getnoise*128.0)+128.0);//Convert to 0-256 values.
            if(color>255)
                color=255;
            if(color<0)
                color=0;
            
            
            //R
            rgba[index++] = color;
            //G
            rgba[index++] = color;
            //B
            rgba[index++] = color;
            
            rgba[index++] = color;
        }
    }
    
    GLuint spriteTexture;
    glGenTextures(1, &spriteTexture);
    glBindTexture(GL_TEXTURE_2D, spriteTexture);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, rgba);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST);
    
    const size_t BitsPerComponent = 8;
    const size_t BytesPerRow=((BitsPerComponent * width) / 8) * 4;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef gtx = CGBitmapContextCreate(&rgba[0], width, height, BitsPerComponent, BytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );

    // create the image:
    CGImageRef toCGImage = CGBitmapContextCreateImage(gtx);
    UIImage * uiimage = [[UIImage alloc] initWithCGImage:toCGImage];
    
    NSData * png = UIImagePNGRepresentation(uiimage);
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"IMAGE.png"]];
    [png writeToFile:databasePath atomically:YES];
    
    free(rgba);
    return spriteTexture;
}
@end
