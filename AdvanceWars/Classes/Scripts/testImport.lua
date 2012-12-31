local pathOfThisFile = package.path

dofile (pathOfThisFile .. "/Scripts/Tile.lua")
dofile (pathOfThisFile .. "/Scripts/TileFactory.lua")
dofile (pathOfThisFile .. "/Scripts/TileMap.lua")
dofile (pathOfThisFile .. "/Scripts/TextureAtlas.lua")
dofile (pathOfThisFile .. "/Scripts/Scene.lua")
dofile (pathOfThisFile .. "/Scripts/utilites.lua")
dofile (pathOfThisFile .. "/Scripts/ColorPickingGenerator.lua")

local tileMapTextureIndices = {}
local tileProperties = {}

tileMapFile = dofile (pathOfThisFile .. "/Scripts/couch.lua")
scene = Scene:new({width=tileMapFile.width, height=tileMapFile.height,verticalPadding=1,horizontalPadding=1})


tileMap = TileMap:new({width=tileMapFile.width, height=tileMapFile.height})


scene:addTileMap(tileMap)

--LOOP for Texture atlases
for index,value in ipairs(tileMapFile.tilesets) do
	--Create texture map
	
	textureAtlas = TextureAtlas:new(value)
	bindTextureToEntity(value.image, tileMap.id)
	textureAtlas:createNormals()
	
	-- create reference map for tiles
	total = (textureAtlas.imagewidth/textureAtlas.tilewidth)*(textureAtlas.imageheight/textureAtlas.tileheight)
	for i = 0, total, 1 do
		tileMapTextureIndices[i+textureAtlas.firstgid] = textureAtlas
	end
	
	--LOOP for special properties of tiles
	for propertyIndex,tile in ipairs(value.tiles) do 
		tileProperties[tile.id] = tile.properties
	end
end

--LOOP
for index,layer in ipairs(tileMapFile.layers) do 
	local width = 0;
	local height = 0;
	for tileIndex,tileID in ipairs(layer.data) do 
		local newTile = TileFactory:createTile(tileProperties[tileID])
		newTile.textureAtlas = tileMapTextureIndices[tileID]
		newTile.normals = textureAtlas.normals[tileID]
		newTile.coords = {{width,height},{width+1,height},{width+1,height+1},{width+1,height+1},{width,height+1},{width,height}}
		newTile.colorPickingColor = ColorPickingGenerator:getColor()
		tileMap:addTile(newTile)
		newTile:createDrawableComponent()
		
				
		width = width + 1
		if(width >= tileMapFile.width) then
			if(height > tileMapFile.height+1) then
				return
			end
			width = 0
			height = height + 1
		end
	end	
end

tileMap:createNormals()
tileMap:createCoords()
tileMap:createColorPickingColors()

updateNormalsForGridComponent(tileMap.id,tileMap.normals)
updateCoordsForGridComponent(tileMap.id,tileMap.coords)
updateColorPickingColorsForGridComponent(tileMap.id,tileMap.colors)