-- Copyright 2013 Arman Darini

local class = {}
class.new = function(o)
	local CameraClass = display.newGroup()
	CameraClass.layer = nil
	CameraClass.viewable = {}
	CameraClass.x = 0
	CameraClass.y = 0
	CameraClass.frozen = false
	CameraClass.timers = {}
	CameraClass.transitions = {}
	CameraClass.state = "ready"

	----------------------------------------------------------
	function CameraClass:init(o)
		self.layer = o.layer
		self.viewable = o.viewable
		self.x = o.x or 0
		self.y = o.y or 0
		self:moveTo(self.x, self.y)
		
		self.layer:addEventListener("touch", self)
		Runtime:addEventListener("cameraPanTo", self)
		return self
	end

	----------------------------------------------------------
	function CameraClass:cameraPanTo(event)
		print("event panTo", event.x, event.y)
		self:panTo(event.x, event.y)
	end

	----------------------------------------------------------
	function CameraClass:transformToLayerCoordinates(x, y)
		return -(x - Game.w / 2), -(y - Game.h / 2)
	end
	
	----------------------------------------------------------
	function CameraClass:clamToViewable(x, y)
		x = math.max((self.viewable.xMin + Game.w / 2), math.min(x, self.viewable.xMax - Game.w / 2))
		y = math.max((self.viewable.yMin + Game.h / 2), math.min(y, self.viewable.yMax - Game.h / 2))
		return x, y
	end

	----------------------------------------------------------
	function CameraClass:moveTo(x, y)
		if true == self.frozen then
			p("camera frozen")
			return
		end
		print("moveTo", x, y)
		self.x, self.y = self:clamToViewable(x, y)
		x, y = self:transformToLayerCoordinates(self.x, self.y)
		self.layer.x = x
		self.layer.y = y
	end

	----------------------------------------------------------
	function CameraClass:moveToCenterBottom()
		self:moveTo(0.5 * (self.viewable.xMin + self.viewable.xMax), self.viewable.yMax)
	end

	----------------------------------------------------------
	function CameraClass:moveToCenterTop()
		self:moveTo(0.5 * (self.viewable.xMin + self.viewable.xMax), self.viewable.yMin)
	end

	----------------------------------------------------------
	function CameraClass:panTo(x, y)
		if true == self.frozen then
			p("camera frozen")
			return
		end
		self.x, self.y = self:clamToViewable(x, y)
		x, y = self:transformToLayerCoordinates(self.x, self.y)
		local d = ((x - self.layer.x)^2 + (y - self.layer.y)^2)^0.5
		transition.to(self.layer, { x = x, y = y, time = d * 10 })
	end

	----------------------------------------------------------
	function CameraClass:startDrag()
		self.startX = self.x
		self.startY = self.y
	end

	----------------------------------------------------------
	function CameraClass:drag(distanceX, distanceY)
		self:moveTo(self.startX - distanceX, self.startY - distanceY)
		Runtime:dispatchEvent({ name = "cameraMoved", camera = self, deltaX = distanceX, deltaY = distanceY })
	end

	----------------------------------------------------------
	function CameraClass:endDrag()
	end

	----------------------------------------------------------
	function CameraClass:freeze()
		self.frozen = true
		self.layer:removeEventListener("touch", self)
		display.getCurrentStage():setFocus(nil)
	end

	----------------------------------------------------------
	function CameraClass:unfreeze()
		self.frozen = false
		self.layer:addEventListener("touch", self)
	end

	----------------------------------------------------------
	function CameraClass:touch(event)
		if "began" == event.phase then
			self:startDrag()
			display.getCurrentStage():setFocus(event.target)
		elseif "moved" == event.phase then
			self:drag(event.x - event.xStart, event.y - event.yStart)
		elseif "ended" == event.phase or "cancelled" == event.phase then
			self:endDrag()
			display.getCurrentStage():setFocus(nil)
			print("camera", self.x, self.y)
		end
		return true
	end

	----------------------------------------------------------
	function CameraClass:toStr()
	end

	----------------------------------------------------------
	function CameraClass:removeSelf()
		Runtime:removeEventListener("cameraPanTo", self)
		for k, _ in pairs(self.timers) do
			timer.cancel(self.timers[k])
			self.timers[k] = nil
		end	
		for k, _ in pairs(self.transitions) do
			transition.cancel(self.transitions[k])
			self.transitions[k] = nil
		end
	end

	----------------------------------------------------------
--	CameraClass:init(o)

	return CameraClass
end

return class