//
//  TileDrawableComponent.m
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/12/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import "GridDrawableComponent.h"
#import "PositionComponent.h"
#import "Vertices.h"
#import "Shader.h"
#import <GLKit/GLKit.h>

@interface GridDrawableComponent()

@property (nonatomic, assign) GLuint columns;
@property (nonatomic, assign) GLuint rows;
@property (nonatomic, assign) GLKVector3 *verts;
@property (nonatomic, assign) GLKVector2 *uvs;
- (void)createGrid;
@end
@implementation GridDrawableComponent

- (void)createGrid
{
    self.verts = malloc(sizeof(GLKVector3)*6*self.columns*self.rows);
    self.uvs = malloc(sizeof(GLKVector2)*6*self.columns*self.rows);
    
    
    for (int i = 0; i < self.rows; i++)
    {
        for (int j = 0; j <self.columns; j++)
        {
            GLKVector3 one = GLKVector3Make(i, j, 0);
            GLKVector3 two = GLKVector3Make(i+1, j, 0);
            GLKVector3 three = GLKVector3Make(i+1, j+1, 0);
            GLKVector3 four = GLKVector3Make(i+1, j+1, 0);
            GLKVector3 five = GLKVector3Make(i, j+1, 0);
            GLKVector3 six = GLKVector3Make(i, j, 0);
            
            _verts[((i*((self.columns*6)))+(j*6))] = one;
            _verts[((i*((self.columns*6)))+(j*6))+1] = two;
            _verts[((i*((self.columns*6)))+(j*6))+2] = three;
            _verts[((i*((self.columns*6)))+(j*6))+3] = four;
            _verts[((i*((self.columns*6)))+(j*6))+4] = five;
            _verts[((i*((self.columns*6)))+(j*6))+5] = six;
            
            /*GLKVector4 color = GLKVector4Make((rand()%255)/255.0, (rand()%255)/255.0, (rand()%255)/255.0, 1);
            
            _colors[((i*((self.columns*6)))+(j*6))] = color;
            _colors[((i*((self.columns*6)))+(j*6))+1] = color;
            _colors[((i*((self.columns*6)))+(j*6))+2] = color;
            _colors[((i*((self.columns*6)))+(j*6))+3] = color;
            _colors[((i*((self.columns*6)))+(j*6))+4] = color;
            _colors[((i*((self.columns*6)))+(j*6))+5] = color;*/
        }
    }

}

- (id)initWithGridColumns:(GLuint)columns gridRows:(GLuint)rows
{
    self = [super init];
    if (self) {
        self.columns = columns;
        self.rows = rows;
    }
    return self;
}

@end
