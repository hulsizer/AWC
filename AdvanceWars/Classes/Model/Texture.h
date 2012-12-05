//
//  Texture.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 12/3/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Texture : NSObject
- (id)initWithTextureName:(NSString*)textureName;
- (void)bind;

@property (nonatomic, assign) GLuint width;
@property (nonatomic, assign) GLuint height;
@end
