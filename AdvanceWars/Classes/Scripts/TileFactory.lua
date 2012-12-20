TileFactory = {}

function TileFactory:createTile(properties)
	local tile = {}
	
	tile = Tile:new(properties)
	
	--if properties["className"] == "GrassGrid"
	--	tile = Tile:new(properties)
	--end
	
	return tile
end