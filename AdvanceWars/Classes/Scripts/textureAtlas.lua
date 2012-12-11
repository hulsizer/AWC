TextureAtlas = {}

function TextureAtlas:new(o)
	o = o or {}
	setmetatable(o,self)
	self.__index = self
	return o
end

function TextureAtlas:createNormals()
	self.normals = {}
	
	if (~(self.imagewidth && self.tilewidth && self.imageheight && self.tileheight))
		print ("Atlas cannot be created because properties were not set")
		return
	end
	
	local numberOfColumns = self.imagewidth/self.tilewidth
	local numberOfRows = self.imageheight/self.tileheight
	for i = 0, numberOfColumns, 1 do
		for j = 0, numberOfRows, 1 do
			self.normals[i*(numberOfColumns)j] ={{i,j,0},
												{i+1,j,0},
												{i+1,j+1,0},
												{i+1,j+1,0},
												{i,j+1,0},
												{i,j,0}}
		end
	end
end