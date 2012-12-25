//
//  ScriptRunner.m
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/9/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import "ScriptRunner.h"
#import "GameDirector.h"
#import "GridDrawableComponent.h"
#import "PositionComponent.h"
#import "Scene.h"
#import "TextureAtlas.h"
#import "Tile.h"
#import "TileMap.h"
#import "EntityManager.h"
#import "Entity.h"

#define DECLARE_CALLBACK(NAME) static int NAME(lua_State *L);

DECLARE_CALLBACK(createLevel)
DECLARE_CALLBACK(createGridComponent)
DECLARE_CALLBACK(createScene)
DECLARE_CALLBACK(createTextureAtlas)
DECLARE_CALLBACK(addTileToTileMap)
DECLARE_CALLBACK(createPositionComponent);
DECLARE_CALLBACK(createEntity);
DECLARE_CALLBACK(createTileMap)
DECLARE_CALLBACK(updateCoordsForGridComponent)
DECLARE_CALLBACK(updateNormalsForGridComponent)

const char *REGISTRY_KEY_DIRECTOR = "director_key";
const char *REGISTRY_KEY_COMPONENT = "component_key";
const char *REGISTRY_KEY_TEXTURE_ATLAS = "textureatlas_key";
const char *REGISTRY_KEY_ENTITY = "entity_key";

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
        
        NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
        
        lua_getglobal( _L, "package" );
        lua_pushstring( _L, [bundlePath cStringUsingEncoding:[NSString defaultCStringEncoding]]); // push the new one
        lua_setfield( _L, -2, "path" ); // set the field "path" in table at -2 with value at top of stack
        lua_pop( _L, 1 ); // get rid of package table from top of stack
        
        [self createNewTable:REGISTRY_KEY_DIRECTOR];
        [self createNewTable:REGISTRY_KEY_COMPONENT];
        [self createNewTable:REGISTRY_KEY_TEXTURE_ATLAS];
        [self createNewTable:REGISTRY_KEY_ENTITY];
        
        lua_pushstring(_L,REGISTRY_KEY_DIRECTOR);                      //["table"]
        lua_pushlightuserdata(_L, (__bridge void *)(director));		//["table",{}]
        lua_settable(_L,LUA_REGISTRYINDEX);                         //[]
        
        //createNewTable(REGISTRY_KEY_DIMENSION);			//create new dimensions
        //createNewTable(REGISTRY_KEY_ACTOR);				//create new actors
        //createNewTable(REGISTRY_KEY_TIMER);				//create new timers
        
        [self setUpCallbacks];

        
        int error;
        NSString *luaFilePath = [[NSBundle mainBundle] pathForResource:[@"Scripts/" stringByAppendingString:script] ofType:@"lua"];
        error = luaL_loadfile(_L, [luaFilePath cStringUsingEncoding:[NSString defaultCStringEncoding]]);
        if (0 != error) {
            luaL_error(_L, "cannot compile lua file: %s",
                       lua_tostring(_L, -1));
            return nil;
            
        }
        
        error = lua_pcall(_L, 0, 0, 0);
        if (0 != error) {
            luaL_error(_L, "cannot run lua file: %s",
                       lua_tostring(_L, -1));
            return nil;
        }
    }
    return self;
}

- (void)setUpCallbacks
{
    [self registerGlobalFunction:"createLevel" withFunction:createLevel];
    [self registerGlobalFunction:"createGridComponent" withFunction:createGridComponent];
    [self registerGlobalFunction:"createScene" withFunction:createScene];
    [self registerGlobalFunction:"createTextureAtlas" withFunction:createTextureAtlas];
    [self registerGlobalFunction:"addTileToTileMap" withFunction:addTileToTileMap];
    [self registerGlobalFunction:"createPositionComponent" withFunction:createPositionComponent];
    [self registerGlobalFunction:"createEntity" withFunction:createEntity];
    [self registerGlobalFunction:"createTileMap" withFunction:createTileMap];
    [self registerGlobalFunction:"updateCoordsForGridComponent" withFunction:updateCoordsForGridComponent];
    [self registerGlobalFunction:"updateNormalsForGridComponent" withFunction:updateNormalsForGridComponent];
}

- (void)createNewTable:(const char*) tableName
{
    lua_pushstring(self.L, tableName);
    lua_newtable(self.L);
    lua_settable(self.L, LUA_REGISTRYINDEX);
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

void pushObjectToTable(lua_State *L, const char *tableName, int objectID)
{
    lua_pushstring(L, tableName);                   //[callbacks,"object"]
    lua_gettable(L, LUA_REGISTRYINDEX);             //[callbacks,objectTable]
    
    lua_pushinteger(L, objectID);                   //[callbacks,objectTable,objectID]
    lua_type(L, -3);                                //[callbacks,objectTable,objectID,callbacks]
    lua_settable(L, -3);                            //[callbacks,objectTable]
    
    lua_pushinteger(L, objectID);                   //[objectID]
}

static GameDirector *getDirector(lua_State *L)
{													// []
	lua_pushstring(L, REGISTRY_KEY_DIRECTOR);		// ["scene"]
	lua_gettable(L, LUA_REGISTRYINDEX);				// [*scene]
	GameDirector *director = (__bridge GameDirector *)lua_touserdata(L, -1);
	assert(director);
	lua_pop(L, 1);									// []
	return director;
}

int createLevel(lua_State *L)
{
    
    
    return 0;
}

int addTileToTileMap(lua_State *L)
{
    GameDirector *director = getDirector(L);
    
    int tileMapID = lua_tonumber(L, -2);
    int tileID = lua_tonumber(L, -1);
    
    TileMap *tileMap = (TileMap*)[director getObject:tileMapID];
    Tile *tile = (Tile*)[director getObject:tileID];
    [tileMap addTile:tile];
    return 0;

}

int createTextureAtlas(lua_State *L)
{    
    NSString *textureName = [NSString stringWithUTF8String:lua_tostring(L, -1)];
    int columns = lua_tonumber(L, -2);
    int rows = lua_tonumber(L, -3);
    
    //Change this
    TextureAtlas *textureAtlas = [[TextureAtlas alloc] initWithTextureName:textureName Width:columns height:rows];
    
    //pushObjectToTable(L, REGISTRY_KEY_TEXTURE_ATLAS, textureAtlas.gid);
    
	return 0;
}


int createEntity(lua_State *L)
{
    GameDirector *director = getDirector(L);
    NSString *name = [NSString stringWithUTF8String:lua_tostring(L, -3)];
    
    Entity *newEntity = [director.entityManager newEntityWithName:name];
    
    pushObjectToTable(L, REGISTRY_KEY_ENTITY, [newEntity.identifier intValue]);
    return 1;
}

int createTileMap(lua_State *L)
{
    return createGridComponent(L);
}

int createScene(lua_State *L)
{
    GameDirector *director = getDirector(L);
    
    int columns = lua_tonumber(L, -2);
    int rows = lua_tonumber(L, -1);
    
    Scene *component = [[Scene alloc] initWithProjection:GLKMatrix4MakeOrtho(0, 13, 10, 0, -1, 2) size:CGSizeMake(columns, rows)];
    
    director.scene = component;
    return 0;
}

int createPositionComponent(lua_State *L)
{
    GameDirector *director = getDirector(L);
    int entity_id = lua_tonumber(L, -3);
    int x = lua_tonumber(L, -2);
    int y = lua_tonumber(L, -1);
    
    PositionComponent *component = [[PositionComponent alloc] init];
    component.point = CGPointMake(x,y);
    
    Entity *entity = [director.entityManager getEntityByIdentifier:[NSNumber numberWithInt:entity_id]];
    [director.entityManager addComponent:component toEntity:entity];
    return 0;
}

int updateNormalsForGridComponent(lua_State *L)
{
    GameDirector *director = getDirector(L);
    
    GridDrawableComponent *component = [[director.scene objects] objectAtIndex:0];// [[GridDrawableComponent alloc] initWithGridColumns:0 gridRows:0];
    int length = luaL_len(L,-1);							//[normals_table]
    GLKVector2 *uvs = malloc(sizeof(GLKVector2)*length);
	for(int i = 1; i <= length; i++)
	{
		lua_rawgeti(L,-1,i);								//[normals_table,vector_table]
        
        lua_rawgeti(L,-1,1);
        float x = lua_tonumber(L,-1);
        lua_pop(L,1);
        
        lua_rawgeti(L,-1,2);
        float y = lua_tonumber(L,-1);
		lua_pop(L,1);
        
        uvs[i-1] = GLKVector2Make(x, y);
        
		lua_pop(L,1);										//[normals_table]
	}
    
    NSMutableData * data = [[NSMutableData alloc] initWithBytes:uvs length:sizeof(GLKVector2)*length];
    SmartVBO *vbo = [[SmartVBO alloc] initWithData:[data mutableBytes] andSize:sizeof(GLKVector2)*length];
    component.vboUVS = vbo;
    
    [component rebind];
    
	return 0;
}

int updateCoordsForGridComponent(lua_State *L)
{
    GameDirector *director = getDirector(L);
    
    GridDrawableComponent *component = [[director.scene objects] objectAtIndex:0];
    
    int length = luaL_len(L,-1);							//[coords_table]
    GLKVector3 *coords = malloc(sizeof(GLKVector3)*length);
	for(int i = 1; i <= length; i++)
	{
		lua_rawgeti(L,-1,i);								//[coords_table,vector_table]
        
        lua_rawgeti(L,-1,1);
        float x = lua_tonumber(L,-1);
        lua_pop(L,1);
        
        lua_rawgeti(L,-1,2);
        float y = lua_tonumber(L,-1);
		lua_pop(L,1);
        
        //lua_rawgeti(L,-1,3);
        //float z = lua_tonumber(L,-1);
		//lua_pop(L,1);
        NSLog(@"%f,%f",x,y);
        coords[i-1] = GLKVector3Make(x, y, 0);
        
		lua_pop(L,1);										//[coords_table]
	}
    
    NSMutableData * data = [[NSMutableData alloc] initWithBytes:coords length:sizeof(GLKVector3)*length];
    SmartVBO *vbo = [[SmartVBO alloc] initWithData:[data mutableBytes] andSize:sizeof(GLKVector3)*length];
    component.vboVerts = vbo;
    
    [component rebind];
	return 0;
}

int createGridComponent(lua_State *L)
{
    GameDirector *director = getDirector(L);
    int entity_id = lua_tonumber(L, -3);
    int columns = lua_tonumber(L, -2);
    int rows = lua_tonumber(L, -1);
    
    GridDrawableComponent *component = [[GridDrawableComponent alloc] initWithGridColumns:columns gridRows:rows];
    
    Entity *entity = [director.entityManager getEntityByIdentifier:[NSNumber numberWithInt:entity_id]];
    [director.entityManager addComponent:component toEntity:entity];
    
    //[director.scene registerObject:component];
    //pushObjectToTable(L, REGISTRY_KEY_COMPONENT, component.id);
    
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
