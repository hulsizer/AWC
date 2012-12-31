TextureAtlas = {}

function TextureAtlas:new(o)
	o = o or {}
	setmetatable(o,self)
	self.__index = self
	createTextureAtlas(o.imagewidth,o.imageheight,o.image)
	return o
end

function TextureAtlas:createNormals()
	self.normals = {}
	
	if ((self.imagewidth and self.tilewidth and self.imageheight and self.tileheight) == nil) then
		print ("Atlas cannot be created because properties were not set")
		return
	end
	
	--Wrong need to be devided by rows and columns
	local numberOfColumns = self.imagewidth/self.tilewidth
	local numberOfRows = self.imageheight/self.tileheight
	for j = 0, numberOfColumns-1, 1 do
		for i = 0, numberOfRows-1, 1 do
			self.normals[i+(numberOfColumns)*j+1] ={{(i/numberOfColumns)+.01,(j/numberOfRows)+.01},
												{((i+1)/numberOfColumns)-0.01,(j/numberOfRows)+.01},
												{((i+1)/numberOfColumns)-0.01,((j+1)/numberOfRows)-0.01},
												{((i+1)/numberOfColumns)-0.01,((j+1)/numberOfRows)-0.01},
												{(i/numberOfColumns)+0.01,((j+1)/numberOfRows)-0.01},
												{(i/numberOfColumns)+0.01,(j/numberOfRows)+0.01}}
		end
	end
end