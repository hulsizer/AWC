Tile = {}

function Tile:new(o)
 	o = o or {}
	setmetatable(o,self)
	self.__index = self
	self.id = createEntity("Grid",self)
	return o
end

function Tile:createDrawableComponent()
	
	createSubDrawableComponent(self.id, self.tileMapID,self.indexInTileMap)
	
end
