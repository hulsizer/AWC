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
        _effect.contantColor = GLKVector4Make((rand()%255)/255.0, (rand()%255)/255.0, (rand()%255)/255.0, 1);
        _numberOfVerts = 6;
        _verts = [[CMVertexAttribArrayBuffer alloc] initWithAttribStride:(sizeof(float)*2) numberOfVertices:_numberOfVerts bytes:glSquareVerts usage:GL_STATIC_DRAW];
        type = e_GRAPHICS;
    }
    return self;
}
- (void)draw:(GLKMatrix4) currentMatrix
{
    //TODO: Optimization would be to not calulate this every time but rather only recalculate when the position moves
    //set up modelView matrix;
    GLKMatrix4 modelViewMatrix = currentMatrix;
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, self.position.point.x, self.position.point.y, 0);
    
    //assign the new model view matrix
    self.effect.transform.modelviewMatrix = modelViewMatrix;
    //bind all glUniforms
    //calculate matrix
    [self.effect prepareToDraw];
    [self.verts prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:2 attribOffset:0 shouldEnable:YES];
    
    [self.verts drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices: self.numberOfVerts];
}
@end
