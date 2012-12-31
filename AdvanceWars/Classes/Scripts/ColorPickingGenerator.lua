ColorPickingGenerator = {r = 255, g = 255, b = 255}

function ColorPickingGenerator:getColor()
	if self.r == 0 then
		if self.g == 0 then
			if self.b== 0 then
				self.r = 255
				self.g = 255
				self.b = 255
			else
				self.b = self.b - 1
			end
		else
			self.g = self.g - 1
		end
	else
		self.r = self.r - 1
	end
	return {{self.r/255,self.g/255,self.b/255}}
end