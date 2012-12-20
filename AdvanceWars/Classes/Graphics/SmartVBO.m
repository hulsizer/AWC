//
//  SmartVBO.m
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/30/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import "SmartVBO.h"

@interface SmartVBO ()
@property (nonatomic, assign) GLuint vboID;
@property (nonatomic, assign) GLvoid* data;
@property (nonatomic, assign) GLuint size;
@property (nonatomic, assign) GLboolean dirty;
@end
@implementation SmartVBO


- (id)initWithData:(GLvoid*) data andSize:(GLuint)size
{
    self = [super init];
    if (self) {
        glGenBuffers(1, &_vboID);
        glBindBuffer(GL_ARRAY_BUFFER, _vboID);
        
        //NSMutableData * nsdata = [[NSMutableData alloc] initWithBytes:data length:size];
        glBufferData(GL_ARRAY_BUFFER, size, data, GL_STREAM_DRAW);
        
        _data = data;
        _size = size;
        
        _dirty = false;
    }
    return self;
}

- (GLboolean)dirty
{
    return _dirty;
}

- (void)rebind
{
    glBindBuffer(GL_ARRAY_BUFFER, _vboID);
    
    glBufferData(GL_ARRAY_BUFFER, _size, _data, GL_STREAM_DRAW);
}

- (void)update
{
    if (_dirty) {
        glBindBuffer(GL_ARRAY_BUFFER,_vboID);
        glBufferData(GL_ARRAY_BUFFER, _size, NULL, GL_STREAM_DRAW);
        //glBindBuffer(GL_ARRAY_BUFFER, _size);
        GLvoid* PositionBuffer = glMapBufferOES(GL_ARRAY_BUFFER, GL_WRITE_ONLY_OES);
        if (PositionBuffer) {
            memcpy(PositionBuffer, _data, _size);
        }
    }
}

- (void)changeDataAtOffset:(GLuint)offset data:(GLvoid*) data size:(GLuint)size
{
    memcpy(&_data[offset], data,size);
    _dirty = true;
}

- (void)bind
{
    glBindBuffer(GL_ARRAY_BUFFER, _vboID);
}
@end
