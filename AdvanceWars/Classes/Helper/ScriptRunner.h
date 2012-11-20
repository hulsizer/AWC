//
//  ScriptRunner.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/9/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GameDirector;

@interface ScriptRunner : NSObject

- (id)initWithDirector:(GameDirector*)director andScript:(NSString*)script;

- (void)registerGlobalFunction:(const char *) name withFunction:(int (*)(lua_State *))function;
- (void)postGlobalNotification;
- (void)postObjectNotification;
@end
