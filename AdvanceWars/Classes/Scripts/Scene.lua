Scene = {verticalPadding = 0, horizontalPadding = 0, width = 0, height =0}

function Scene:new(o)
	o = o or {}
	setmetatable(o,self)
	self.__index = self
	print(o.width)
	createScene(o.width+o.horizontalPadding*2,o.height+o.verticalPadding*2)
	return o
end

function Scene:addTileMap(tileMap)
	self.tileMap = tileMap
	self.width = tileMap.width+self.verticalPadding
	self.height = tileMap.height+self.horizontalPadding;
end