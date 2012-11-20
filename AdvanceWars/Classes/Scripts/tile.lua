function makeTile(x,y)
	local self = {}
	 self.id = createComponent(x,y)
	self.positionComponent = makePositionComonent()
	self.drawableComponent = makeDrawableComponent()
	
	self.handleExternalMessage = function(category,componentID, message)
	
	end

	self.handleInternalMessage = function(category,componentID, message)
	
	end
	
  
end

