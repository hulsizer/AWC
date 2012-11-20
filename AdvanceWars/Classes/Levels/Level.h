//
//  Level.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/11/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import <GameDirector.h>

@interface Level : GameDirector

- (id)initWithLuaFile:(NSString*)fileName luaState:(lua_State *)L;
@end
