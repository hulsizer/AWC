TileMap = {width = 0, height = 0, numberOfTiles = 0, tiles = {}}

function TileMap:new(o)
	o = o or {}
	setmetatable(o,self)
	self.__index = self
	self.id = createEntity("tile",self)
	createPositionComponent(self.id,1,1)
	createTileMap(self.id, o.width,o.height)
	
	return o
end

function TileMap:addTile(tile)
	if tile == nil then
		return
	end
	table.insert(self.tiles,tile)
	tile.tileMapID = self.id
	tile.indexInTileMap = self.numberOfTiles
	--self.tiles[self.numberOfTiles] = tile
	self.numberOfTiles = self.numberOfTiles + 1
end

function TileMap:createNormals()
	self.normals = {}
	for key, tile in ipairs(self.tiles) do
		--add the normals of each tile to list
		self.normals = joinTables(self.normals, tile.normals)
	end
end

function TileMap:createCoords()
	self.coords = {}
	for key, tile in ipairs(self.tiles) do
		--add the coords of each tile to list
		self.coords = joinTables(self.coords, tile.coords)
	end
end

function TileMap:createColorPickingColors()
	self.colors = {}
	for key, tile in ipairs(self.tiles) do
		--add the normals of each tile to list
		self.colors = joinTables(self.colors, tile.colorPickingColor)
	end
end