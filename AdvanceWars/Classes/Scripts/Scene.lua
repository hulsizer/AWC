Scene = {verticalPadding = 0, horizontalPadding = 0, width = 0, height =0}

function Scene:new(o)
	o = o or {}
	setmetatable(o,self)
	self.__index = self
	return o
end

function Scene:addTileMap(tileMap)
	self.tileMap = tileMap
	self.width = tileMap.width+verticalPadding
	self.height = tileMap.height+horizontalPadding;
end