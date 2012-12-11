TileFactory = {}

function TileFactory:createTile(properties)
	local tile = {}
	
	if properties["className"] == "GrassGrid"
		tile = GrassTile:new()
	end
	
	return tile
end