//
//  SmartVBO.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/30/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SmartVBO : NSObject
- (id)initWithData:(GLvoid*) data andSize:(GLuint)size;
- (GLboolean)dirty;
- (void)update;
- (void)bind;
- (void)changeDataAtOffset:(GLuint)offset data:(GLvoid*) data size:(GLuint)size;
@end
