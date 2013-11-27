-- Copyright 2013 Arman Darini

local class = {}
class.new = function(o)
	local LettersPuzzleClass = {}
	LettersPuzzleClass.layer = nil
	LettersPuzzleClass.view = nil
	LettersPuzzleClass.timers = {}
	LettersPuzzleClass.transitions = {}
	LettersPuzzleClass.sheetInfo = require("assets.images.sheet-1x")
	LettersPuzzleClass.sheet = graphics.newImageSheet("assets/images/sheet-1x.png", LettersPuzzleClass.sheetInfo:getSheet())
--	LettersPuzzleClass.category = ""
	LettersPuzzleClass.text = ""
	LettersPuzzleClass.solution = ""
	LettersPuzzleClass.spotlightOffset = 75
	
	----------------------------------------------------------
	function LettersPuzzleClass:init(o)
		self.layer = o.layer
--		self.category = o.category
		self.text = o.text
		self.mask = graphics.newMask("assets/images/spotlight.png")
		
		self:show()		
		return self
	end

	----------------------------------------------------------
	function LettersPuzzleClass:show()
		self.view = display.newGroup()

		self.view.bg = display.newRect(self.view, 0, 0, Game.w * 1, Game.h * 1)
		self.view.bg.anchorY = 0
		self.view.bg:setFillColor(1)
		self.view.bg.stroke = { 1, 1, 1 }
		self.view.bg.strokeWidth = 4

		self.view.letters = display.newGroup()
		self.view.letterHotSpots = display.newGroup()
		local location = { x = { 0, 50, 100, -100, -50 }, y = { 250, 50, 100, 150, 200 } }
		for i = 1, #self.text do
	    local char = self.text:sub(i, i)
			self.view.letters[i] = display.newText(self.view.letters, char, location.x[i], location.y[i], Game.fontBold, 40)
			table.insert(self.view.letters, self.view.letters[i])
			self.view.letters[i]:setFillColor(0)

			self.view.letterHotSpots[i] = display.newText(self.view.letterHotSpots, char, location.x[i], location.y[i] + self.spotlightOffset, Game.fontBold, 40)
			self.view.letterHotSpots[i].view = self.view.letters[i]
			self.view.letterHotSpots[i].letter = char
			self.view.letterHotSpots[i].addedToSolution = false
			table.insert(self.view.letterHotSpots, self.view.letterHotSpots[i])
			self.view.letterHotSpots[i]:setFillColor(1)
			self.view.letterHotSpots[i].alpha = 0.05
		end
		self.view:insert(self.view.letters)
		self.view:insert(self.view.letterHotSpots)

		self.view:setMask(self.mask)
--		self.view:setMask(nil)
		self.view.maskX = 0
		self.view.maskY = -100
		self.view.maskScaleX = 0.15
		self.view.maskScaleY = 0.15
		self.view.isHitTestMasked = false

		self.view.owner = self
	end

	----------------------------------------------------------
	function LettersPuzzleClass:start()
		self.view:addEventListener("touch", self)
		for i = 1, #self.view.letters do
			self.view.letterHotSpots[i]:addEventListener("touch", function(event) self:letterTouch(event) end)
		end
--		self:solved()
	end

	----------------------------------------------------------
	function LettersPuzzleClass:solved()
		self.view:removeEventListener("touch", self)
		for i = 1, #self.view.letters do
			self.view.letterHotSpots[i]:removeEventListener("touch", function(event) self:letterTouch(event) end)
		end
		self.view:setMask(nil)
		display.remove(self.view.letterHotSpots)

		for i = 1, #self.view.letters do
			transition.to(self.view.letters[i], { time = 2000, x = 0, y = Game.centerY + (i - 3) * 50 })
			transition.to(self.view.letters[i], { time = 5000, delay = 3000, xScale = 200, yScale = 200, y = (i - 3) * 5000, transition = easing.inQuint })
			transition.to(self.view, { time = 500, delay = 7000, alpha = 0 })
		end
	end
	
	----------------------------------------------------------
	function LettersPuzzleClass:letterTouch(event)
		if event.target.addedToSolution then
			return
		end
		
		self.solution = self.solution .. event.target.letter
		event.target.addedToSolution = true

		if #self.solution == #self.text then
			event.target.view:setFillColor(1, 0, 0)
			self:solved()
		elseif self.solution:len() > 1 and 1 ~= self.text:find(self.solution) then
			for i = 1, #self.view.letters do
				self.view.letters[i]:setFillColor(0)
				self.view.letterHotSpots[i].addedToSolution = false
			end
			self.solution = event.target.letter
			event.target.addedToSolution = true
			event.target.view:setFillColor(1, 0, 0)
		else
			event.target.view:setFillColor(1, 0, 0)
		end
		p(self.solution)
	end
	
	----------------------------------------------------------
	function LettersPuzzleClass:touch(event)
		local x = event.x - Game.centerX
		local y = event.y
		if "began" == event.phase then
			self.view.maskX = x
			self.view.maskY = y - self.spotlightOffset
		elseif "moved" == event.phase then
			self.view.maskX = x
			self.view.maskY = y - self.spotlightOffset
		elseif "ended" == event.phase or "cancelled" == event.phase then
			self.view.maskX = 0
			self.view.maskY = -100
		end
	end

	----------------------------------------------------------
	function LettersPuzzleClass:removeSelf()
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
	LettersPuzzleClass:init(o)

	return LettersPuzzleClass
end

return class
