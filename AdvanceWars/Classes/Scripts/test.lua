function makeTile(x,y)
	local self = {}
	
	self.id = createEntity()
	
	self.positionComponent = makePositionComonent(self.id,x,y)
	self.drawableComponent = makeDrawableComponent(self.id)
end

