local tileFactory = TileFactory:new()
local tileMapTextureIndices = {}

tileMapFile = dofile("tilemap.lua")

tileMap = TileMap:new({tileMapFile.width, tileMapFile.height})

scene = Scene:new({verticalPadding=1,horizontalPadding=1})
scene:addTileMap(tileMap)

--LOOP for Texture atlases
for index,value in ipairs(tileMapFile.tilesets) do
	--Create texture map
	
	textureAtlas = TextureAtlas:new(value)
	textureAtlas:createNormals()
	
	-- create reference map for tiles
	total = (textureAtlas.tilewidth/textureAtlas.imagewidth)*(textureAtlas.tileheight/textureAtlas.imageheight)
	for i = 0, total, 1 do
		tileMapTextureIndices[i+textureAtlas.firstgrid] = textureAtlas
	end
	
	--LOOP for special properties of tiles
	for propertyIndex,tile in ipairs(value.tiles) do 
		properties[tile.id] = tile.properties
	end
end

--LOOP
for index,layer in ipairs(tileMapFile.layers) do 
	for tileIndex,tileID in ipairs(layer) do 
		local newTile = TileFactory:createTile(properties[tileID])
		newTile.textureAtlas = tileMapTextureIndices[tileID]
		newTile.normals = textureAtlas.normals[tileID]
		tileMap:addTile(newTile)
	end	
end

tileMap.createNormals()
