//
//  ScriptRunner.m
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/9/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import "ScriptRunner.h"
#import "GameDirector.h"

#define DECLARE_CALLBACK(NAME) static int NAME(lua_State *L);

DECLARE_CALLBACK(createLevel)

const char *REGISTRY_KEY_LEVEL = "level_key";


@interface ScriptRunner()
@property (nonatomic, assign) lua_State *L;
@end

@implementation ScriptRunner

- (id)initWithDirector:(GameDirector*)director andScript:(NSString*)script
{
    self = [super init];
    if (self) {
        _L = luaL_newstate();
        luaL_openlibs(_L);
        
        lua_settop(_L, 0);
        
        lua_pushstring(_L,REGISTRY_KEY_LEVEL);                      //["table"]
        lua_pushlightuserdata(_L, (__bridge void *)(director));		//["table",{}]
        lua_settable(_L,LUA_REGISTRYINDEX);                         //[]
        
        [self createNewTable:REGISTRY_KEY_LEVEL];
        
        //createNewTable(REGISTRY_KEY_DIMENSION);			//create new dimensions
        //createNewTable(REGISTRY_KEY_ACTOR);				//create new actors
        //createNewTable(REGISTRY_KEY_TIMER);				//create new timers
        
        [self setUpCallbacks];
        
        if(luaL_loadfile(_L, [script UTF8String]) != 0)
        {
            printf("ERROR WITH LUA FILE!!");
            return NULL;
        }
        
        if (LUA_ERRRUN == lua_pcall(_L,0,0,0)) {
            printf("lua runtime error: ");
        }
    }
    return self;
}

- (void)setUpCallbacks
{
    [self registerGlobalFunction:"createLevel" withFunction:createLevel];
}

- (void)createNewTable:(const char*) tableName
{
    lua_pushstring(self.L, tableName);
    lua_newtable(self.L);
    lua_settable(self.L, LUA_REGISTRYINDEX);
}

- (void) pushObjectToTable:(lua_State *) L tableName:(const char *)tableName objectID:(int)objectID
{
    lua_pushstring(L, tableName);                   //[callbacks,"object"]
    lua_gettable(L, LUA_REGISTRYINDEX);             //[callbacks,objectTable]

    lua_pushinteger(L, objectID);                   //[callbacks,objectTable,objectID]
    lua_type(L, -3);                                //[callbacks,objectTable,objectID,callbacks]
    lua_settable(L, -3);                            //[callbacks,objectTable]
    
    lua_pushinteger(L, objectID);                   //[objectID]
}

- (void)registerGlobalFunction:(const char *) name withFunction:(int (*)(lua_State *))function
{
    lua_pushcfunction(self.L, function);
    lua_setglobal(self.L, name);
}

- (void)postGlobalNotification
{
    
}

- (void)postObjectNotification
{
    
}

@end

int createLevel(lua_State *L)
{
    
    
    return 0;
}

int createPhysicsComponent(lua_State *L)
{
    return 0;
}

int createDrawableComponent(lua_State *L)
{
    return 0;
}

int createComponent(lua_State *L)
{
    return 0;
}
