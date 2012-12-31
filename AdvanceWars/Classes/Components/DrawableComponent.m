//
//  DrawableComonent.m
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/11/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import "DrawableComponent.h"
#import "PositionComponent.h"
#import "CMVertexAttribArrayBuffer.h"
#import "CMEffect.h"
#import "Vertices.h"
@interface DrawableComponent()

@property (nonatomic, strong) CMVertexAttribArrayBuffer *verts;
@property (nonatomic, assign) GLsizei numberOfVerts;
@end

@implementation DrawableComponent

- (id)init
{
    self = [super init];
    if (self) {
        _effect = [[CMEffect alloc] init];
        type = @"DrawableComponent";
        self.vboUVS = nil;
        self.vboVerts = nil;
        self.vboColors = nil;
        glGenVertexArraysOES(1, &_vao);
        glBindVertexArrayOES(_vao);
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

- (void)draw:(GLKMatrix4) currentMatrix mode:(enum DrawMode)mode
{
    GLKMatrix4 modelViewMatrix = currentMatrix;
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, self.position.point.x, self.position.point.y, 0);
    
    //assign the new model view matrix
    self.effect.transform.modelviewMatrix = modelViewMatrix;
    [self.effect bindProgram];
    [self.effect bindTextures];
    [self.effect bindUniforms];
    
    
    
    glBindVertexArrayOES(_vao);
    
    glDrawArrays(GL_TRIANGLES, 0, self.numberOfVerts);
    
    glBindVertexArrayOES(0);
}
@end
