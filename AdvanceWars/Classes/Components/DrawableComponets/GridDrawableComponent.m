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

- (void)createGrid;
@end
@implementation GridDrawableComponent

- (void)createGrid
{
    /*self.verts = malloc(sizeof(GLKVector3)*VERTS_PER_SQUARE*self.columns*self.rows);
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
            
            /*
            _uvs[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))] = GLKVector2Make(one.x,one.y);
            _uvs[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))+1] = GLKVector2Make((two.x),two.y);
            _uvs[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))+2] = GLKVector2Make((three.x),(three.y));
            _uvs[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))+3] = GLKVector2Make((four.x),(four.y));
            _uvs[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))+4] = GLKVector2Make((five.x),(five.y));
            _uvs[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))+5] = GLKVector2Make((six.x),(six.y));
            */
            /*
            _uvs[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))] = GLKVector2Make(one.x/self.rows,one.y/self.columns);
            _uvs[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))+1] = GLKVector2Make((two.x)/self.rows,two.y/self.columns);
            _uvs[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))+2] = GLKVector2Make((three.x)/self.rows,(three.y)/self.columns);
            _uvs[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))+3] = GLKVector2Make((four.x)/self.rows,(four.y)/self.columns);
            _uvs[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))+4] = GLKVector2Make((five.x)/self.rows,(five.y)/self.columns);
            _uvs[((i*((self.columns*VERTS_PER_SQUARE)))+(j*VERTS_PER_SQUARE))+5] = GLKVector2Make((six.x)/self.rows,(six.y)/self.columns);
            
        }
    }
    
    NSMutableData * data = [[NSMutableData alloc] initWithBytes:_verts length:sizeof(GLKVector3)*6*self.columns*self.rows];
    NSMutableData * color_data = [[NSMutableData alloc] initWithBytes:_colors length:sizeof(GLKVector4)*6*self.columns*self.rows];
    NSMutableData * uv_data = [[NSMutableData alloc] initWithBytes:_uvs length:sizeof(GLKVector2)*6*self.columns*self.rows];
*/
    //Create new VAO and VBOS
    glGenVertexArraysOES(1, &_vao);
    glBindVertexArrayOES(_vao);
    
    //glGenBuffers(1, &_vboVerts);
    //glBindBuffer(GL_ARRAY_BUFFER, _vboVerts);
    
    //self.vboVerts = [[SmartVBO alloc] initWithData:[data mutableBytes] andSize:[data length]];
    
    //glEnableVertexAttribArray(GLKVertexAttribPosition);
    //glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLKVector3), 0);
    
    //Will be UVS eventually
    //self.vboColors = [[SmartVBO alloc] initWithData:[color_data mutableBytes] andSize:[color_data length]];
    
    //glEnableVertexAttribArray(GLKVertexAttribColor);
    //glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(GLKVector4), 0);
    
    //Will be UVS eventually
    //self.vboUVS = [[SmartVBO alloc] initWithData:[uv_data mutableBytes] andSize:[uv_data length]];
    
    //glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    //glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLKVector2), 0);
    
    glBindVertexArrayOES(0);

}

- (id)initWithGridColumns:(GLuint)columns gridRows:(GLuint)rows
{
    self = [super init];
    if (self) {
        self.columns = columns;
        self.rows = rows;
        self.vboUVS = nil;
        self.vboVerts = nil;
        self.vboColors = nil;
        [self createGrid];
    }
    return self;
}

- (void)rebind
{
    glBindVertexArrayOES(_vao);
    
    //glGenBuffers(1, &_vboVerts);
    //glBindBuffer(GL_ARRAY_BUFFER, _vboVerts);
    if (self.vboVerts) {
        [self.vboVerts bind];
    
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLKVector3), 0);
    }
    
    if (self.vboColors) {
        [self.vboColors bind];
        glEnableVertexAttribArray(GLKVertexAttribColor);
        glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(GLKVector4), 0);
    }

    
    if (self.vboUVS) {
        [self.vboUVS bind];
        glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
        glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLKVector2), 0);
    }
    
   
    
    glBindVertexArrayOES(0);

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
    
    glDrawArrays(GL_TRIANGLES, 0, VERTS_PER_SQUARE*self.columns*self.rows);
    
    glBindVertexArrayOES(0);
}

@end
