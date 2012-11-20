//
//  TextureGroup.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/16/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextureGroup : NSObject
@property (nonatomic, assign) NSString *identifer;
- (void)addTexture:(GLint)newTexture;
- (void)bind;
- (NSString*)identifer;
@end
