TileMap = {width = 0, height = 0, numberOfTiles = 0}

function TileMap:new(o)
	o = o or {}
	setmetatable(o,self)
	self.__index = self
	return o
end

function TileMap:addTile(tile)
	if (~tile)
		return
	
	self.tiles.insert(tile,numberOfTiles)
	numberOfTiles++
end

function TileMap:createNormals()
	self.normals = {}
	for key, tile in ipairs(self.tiles) do
		--add the normals of each tile to list
		self.normals = joinTables(self.normals, tile.normals)
	end
end