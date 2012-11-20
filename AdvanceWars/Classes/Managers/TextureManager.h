//
//  TextureManager.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/16/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TextureGroup;
@interface TextureManager : NSObject

- (TextureGroup*)texturesForKey:(NSString*)key;
@end
