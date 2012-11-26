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
#import "CMEffect.h"
#import <GLKit/GLKit.h>


#define VERTS_PER_SQUARE 6

@interface GridDrawableComponent()

@property (nonatomic, assign) GLuint columns;
@property (nonatomic, assign) GLuint rows;
@property (nonatomic, assign) GLKVector3 *verts;
@property (nonatomic, assign) GLKVector2 *uvs;
@property (nonatomic, assign) GLKVector4 *colors;
@property (nonatomic, assign) GLuint vao;
@property (nonatomic, assign) GLuint vboVerts;
@property (nonatomic, assign) GLuint vboUVS;
@property (nonatomic, assign) GLuint vboColors;
- (void)createGrid;
@end
@implementation GridDrawableComponent

- (void)createGrid
{
    self.verts = malloc(sizeof(GLKVector3)*VERTS_PER_SQUARE*self.columns*self.rows);
    self.uvs = malloc(sizeof(GLKVector2)*VERTS_PER_SQUARE*self.columns*self.rows);
    self.colors = malloc(sizeof(GLKVector4)*VERTS_PER_SQUARE*self.columns*self.rows);
    
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
            
            _verts[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))] = one;
            _verts[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))+1] = two;
            _verts[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))+2] = three;
            _verts[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))+3] = four;
            _verts[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))+4] = five;
            _verts[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))+5] = six;
            
            GLKVector4 color = GLKVector4Make((rand()%255)/255.0, (rand()%255)/255.0, (rand()%255)/255.0, 1);
            
            _colors[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))] = color;
            _colors[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))+1] = color;
            _colors[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))+2] = color;
            _colors[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))+3] = color;
            _colors[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))+4] = color;
            _colors[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))+5] = color;
            
            
            _uvs[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))] = GLKVector2Make(0,0);
            _uvs[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))+1] = GLKVector2Make(1,0);;
            _uvs[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))+2] = GLKVector2Make(1,1);;
            _uvs[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))+3] = GLKVector2Make(1,1);;
            _uvs[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))+4] = GLKVector2Make(0,1);;
            _uvs[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))+5] = GLKVector2Make(0,0);;
        }
    }

    //Create new VAO and VBOS
    glGenVertexArraysOES(1, &_vao);
    glBindVertexArrayOES(_vao);
    
    glGenBuffers(1, &_vboVerts);
    glBindBuffer(GL_ARRAY_BUFFER, _vboVerts);
    
    NSMutableData * data = [[NSMutableData alloc] initWithBytes:_verts length:sizeof(GLKVector3)*6*self.columns*self.rows];
    NSMutableData * color_data = [[NSMutableData alloc] initWithBytes:_colors length:sizeof(GLKVector4)*6*self.columns*self.rows];
    NSMutableData * uv_data = [[NSMutableData alloc] initWithBytes:_uvs length:sizeof(GLKVector2)*6*self.columns*self.rows];
    
    glBufferData(GL_ARRAY_BUFFER, [data length], [data bytes], GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLKVector3), 0);
    
    //Will be UVS eventually
    glGenBuffers(1, &_vboColors);
    glBindBuffer(GL_ARRAY_BUFFER, _vboColors);
    glBufferData(GL_ARRAY_BUFFER, [color_data length], [color_data bytes], GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(GLKVector4), 0);
    
    //Will be UVS eventually
    glGenBuffers(1, &_vboUVS);
    glBindBuffer(GL_ARRAY_BUFFER, _vboUVS);
    glBufferData(GL_ARRAY_BUFFER, [uv_data length], [uv_data bytes], GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLKVector2), 0);
    
    glBindVertexArrayOES(0);

}

- (id)initWithGridColumns:(GLuint)columns gridRows:(GLuint)rows
{
    self = [super init];
    if (self) {
        self.columns = columns;
        self.rows = rows;
        
        [self createGrid];
    }
    return self;
}

- (void)draw:(GLKMatrix4)currentMatrix
{
    
    GLKMatrix4 modelViewMatrix = currentMatrix;
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, self.position.point.x, self.position.point.y, 0);
    
    //assign the new model view matrix
    self.effect.transform.modelviewMatrix = modelViewMatrix;
    [self.effect bindProgram];
    [self.effect bindTextures];
    [self.effect bindUniforms];
    

    
    glBindVertexArrayOES(_vao);
    
    glDrawArrays(GL_TRIANGLES, 0, 6*25*25);
    
    glBindVertexArrayOES(0);
}

@end
