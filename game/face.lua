-- Copyright 2013 Arman Darini

local class = {}
class.new = function(o)
	local FaceClass = {}
	FaceClass.layer = nil
	FaceClass.view = nil
	FaceClass.timers = {}
	FaceClass.transitions = {}
	FaceClass.sheetInfo = require("assets.images.sheet-1x")
	FaceClass.sheet = graphics.newImageSheet("assets/images/sheet-1x.png", FaceClass.sheetInfo:getSheet())
	FaceClass.category = ""
	FaceClass.soundId = ""
	FaceClass.text = ""
	FaceClass.location = {}
	FaceClass.orientation = ""
	
	FaceClass.animationSequences =
	{
		face01 = {
			{ name = "default", start = 1, count = 13, time = 1000 },
		},
		face02 = {
			{ name = "default", start = 14, count = 13, time = 1000 },
		},
	}	

	----------------------------------------------------------
	function FaceClass:init(o)
		self.layer = o.layer
		self.category = o.category
		self.soundId = o.soundId
		self.text = o.text
		self.location = o.location or { 50, 150, 300, 400 }
		self.orientation = o.orientation
		
		Runtime:addEventListener("cameraMoved", self)
		
		self.view = display.newGroup()
		self.view.anchorChildren = true
		self.view.face = display.newSprite(self.view, self.sheet, self.animationSequences[self.category])

		self.view.message = display.newText(self.view, self.text, 0, 0, Game.font, 20)
		self.view.message:setFillColor(0)
		self.view.message.anchorX = 0
		self.view.message.x = 50

		self.view.owner = self
		if "left" == self.orientation then
			self.view.face.xScale = -1
			self.view.message.x = -self.view.message.width - 50
		end

		self:show()
		return self
	end

	----------------------------------------------------------
	function FaceClass:show()
		local x, y = self.view:localToContent(0, 0)
--		print("FaceClass:show x=", x, " y=", y)
		local frame

		if y < self.location[1] then
			self.view.alpha = 0
		elseif y < self.location[2] then
			self.view.alpha = 1
			self.view.message.alpha = 0
			frame = math.clamp(math.round(self.view.face.numFrames * (y - self.location[1]) / (self.location[2] - self.location[1])), 1, self.view.face.numFrames)
			self.view.face:setFrame(frame)

			if audio.isChannelPlaying(2) then
				audio.stop(2)
			end
		elseif y < self.location[2] + 0.5 * (self.location[3] - self.location[2]) then
			self.view.alpha = 1
			self.view.message.alpha = 2 * (y - self.location[2]) / (self.location[3] - self.location[2])
			self.view.face:setFrame(self.view.face.numFrames)

			if not audio.isChannelPlaying(2) then
				audio.play(Sounds.face[self.soundId], { channel = 2, loops = -1 })
			end
		elseif y < self.location[3] then
			self.view.alpha = 1
			self.view.message.alpha = 2 * (self.location[3] - y) / (self.location[3] - self.location[2])
			self.view.face:setFrame(self.view.face.numFrames)

			if not audio.isChannelPlaying(2) then
				audio.play(Sounds.face[self.soundId], { channel = 2, loops = -1 })
			end
		elseif y < self.location[4] then
			self.view.alpha = 1
			self.view.message.alpha = 0
			frame = math.clamp(math.round(self.view.face.numFrames * (self.location[4] - y) / (self.location[4] - self.location[3])), 1, self.view.face.numFrames)
			self.view.face:setFrame(frame)

			if audio.isChannelPlaying(2) then
				audio.stop(2)
			end
		else
			self.view.alpha = 0
		end
	end

	----------------------------------------------------------
	function FaceClass:cameraMoved(event)
		self:show()
	end

	----------------------------------------------------------
	function FaceClass:removeSelf()
		Runtime:removeEventListener("cameraMoved", self)

		for k, _ in pairs(self.timers) do
			timer.cancel(self.timers[k])
			self.timers[k] = nil
		end	
		for k, _ in pairs(self.transitions) do
			transition.cancel(self.transitions[k])
			self.transitions[k] = nil
		end	
		display.remove(self.view)
	end

	----------------------------------------------------------
	FaceClass:init(o)

	return FaceClass
end

return class
