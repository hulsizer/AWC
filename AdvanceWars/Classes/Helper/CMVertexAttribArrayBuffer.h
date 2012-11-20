//
//  CMVertexAttribArrayBuffer.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/14/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMVertexAttribArrayBuffer : NSObject

@property (nonatomic, readonly) GLuint name;
@property (nonatomic, readonly) GLsizeiptr bufferSizeBytes;
@property (nonatomic, readonly) GLsizeiptr stride;

+ (void)drawPreparedArraysWithMode:(GLenum)mode
				  startVertexIndex:(GLint)first
				  numberOfVertices:(GLsizei)count;

- (id)initWithAttribStride:(GLsizeiptr)stride
		  numberOfVertices:(GLsizei)count
					 bytes:(const GLvoid *)dataPtr
					 usage:(GLenum)usage;

- (void)prepareToDrawWithAttrib:(GLuint)index
			numberOfCoordinates:(GLint)count
				   attribOffset:(GLsizeiptr)offset
				   shouldEnable:(BOOL)shouldEnable;

- (void)drawArrayWithMode:(GLenum)mode
		 startVertexIndex:(GLint)first
		 numberOfVertices:(GLsizei)count;

- (void)reinitWithAttribStride:(GLsizeiptr)stride
			  numberOfVertices:(GLsizei)count
						 bytes:(const GLvoid *)dataPtr;
@end
