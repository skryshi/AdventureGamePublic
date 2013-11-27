-- Copyright 2013 Arman Darini
local scene = Storyboard.newScene()
local FaceClass = require("game.face")
local LettersPuzzleClass = require("game.letters_puzzle")

----------------------------------------------------------
function scene:tap(event)
	if "header" == self.state then
		self.state = "blink"
		self:showBlink()
	elseif "blink" == self.state then
		self.state = "doctorsDialog"
		self:showDoctorsDialog()
	elseif "doctorsDialog" == self.state then
		self.state = ""
		Storyboard.gotoScene("game.scenes.waking_up")
	end
end

----------------------------------------------------------
function scene:cameraMoved(event)
	if Game.centerY == self.camera.y then
		self.camera:freeze()
		self.view.content.puzzle:start()
	end
end


----------------------------------------------------------
function scene:showBlink()
	layers:removeEventListener("tap", showBlink)

	display.setDefault("fillColor", 0, 0, 0)
	self.view.content.blinkTop = display.newRect(self.view.content, Game.centerX, 0, Game.w, Game.h)
	self.view.content.blinkBottom = display.newRect(self.view.content, Game.centerX, Game.h, Game.w, Game.h)
	
	transition.to(self.view.content.blinkTop, { time = 1000, height = 0, onComplete = hideBlink })
	transition.to(self.view.content.blinkBottom, { time = 1000, height = 0, onComplete = hideBlink })
end

----------------------------------------------------------
function scene:hideBlink()
	print("hideBlink")
	display.remove(self.view.content.blinkTop)
	display.remove(self.view.content.blinkBottom)
	layers:addEventListener("touch", scrollListener)
end

----------------------------------------------------------
function scene:showArrow()
	print("showArrow")
	self.view.content.dialog.arrow = display.newGroup()
	display.setDefault("lineColor", 0, 0, 0)
	self.view.content.dialog.arrow.one = display.newLine(self.view.content.dialog.arrow, 0, 0, 20, 20)
	self.view.content.dialog.arrow.two = display.newLine(self.view.content.dialog.arrow, 0, 0, -20, 20)
	self.view.content.dialog.arrow.three = display.newLine(self.view.content.dialog.arrow, 0, 0, 0, 150)
--	self.view.content.dialog.arrow.three.stroke = {1, 1, 1}
--	self.view.content.dialog.arrow.three.stroke.effect = "generator.marchingAnts"

	self.view.content.dialog:insert(self.view.content.dialog.arrow)	
	self.view.content.dialog.arrow.y = self.view.content.dialog.height - self.view.content.dialog.arrow.height - 10
end

----------------------------------------------------------
function scene:showFaces()
	self.view.content.dialog.face1 = FaceClass.new({ layer = self.view.content.dialog, orientation = "left", category = "face01", soundId = "face01", text = "Wake up..." })
	self.view.content.dialog:insert(self.view.content.dialog.face1.view)
	self.view.content.dialog.face1.view.anchorX = 1
	self.view.content.dialog.face1.view.x = Game.w * 0.49
	self.view.content.dialog.face1.view.y = 6 * Game.h

	self.view.content.dialog.face2 = FaceClass.new({ layer = self.view.content.dialog, orientation = "left", category = "face01", soundId = "face02", text = "Wake up now!" })
	self.view.content.dialog:insert(self.view.content.dialog.face2.view)
	self.view.content.dialog.face2.view.anchorX = 1
	self.view.content.dialog.face2.view.x = Game.w * 0.49
	self.view.content.dialog.face2.view.y = 5 * Game.h
	
	self.view.content.dialog.response1 = display.newText(self.view.content.dialog, "I can't.", 0, 4 * Game.h, Game.fontItalic, 20)
	self.view.content.dialog.response1:setFillColor(0)
	
	self.view.content.dialog.face3 = FaceClass.new({ layer = self.view.content.dialog, orientation = "right", category = "face02", soundId = "face03", text = "Did you die?" })
	self.view.content.dialog:insert(self.view.content.dialog.face3.view)
	self.view.content.dialog.face3.view.anchorX = 0
	self.view.content.dialog.face3.view.x = -Game.w * 0.47
	self.view.content.dialog.face3.view.y = 3 * Game.h

	self.view.content.dialog.response2 = display.newText(self.view.content.dialog, "No.", 0, 2 * Game.h, Game.fontItalic, 20)
	self.view.content.dialog.response2:setFillColor(0)
	
	self.view.content.dialog.face4 = FaceClass.new({ layer = self.view.content.dialog, orientation = "right", category = "face02", soundId = "face04", text = "When will you die?" })
	self.view.content.dialog:insert(self.view.content.dialog.face4.view)
	self.view.content.dialog.face4.view.anchorX = 0
	self.view.content.dialog.face4.view.x = -Game.w * 0.47
	self.view.content.dialog.face4.view.y = 1 * Game.h
end

----------------------------------------------------------
function scene:showDialog()
	self.view.content.dialog = display.newGroup()
	self.view.content.dialog.bg = display.newRect(self.view.content.dialog, 0, 0, Game.w * 1, Game.h * 7.5)
	self.view.content.dialog.bg.anchorY = 0
	self.view.content.dialog.bg:setFillColor(1)
	
	self.view.content.dialog.anchorChildren = true
	self.view.content.dialog.anchorY = 1
	self.view.content.dialog.x = Game.centerX
	self.view.content.dialog.y = self.view.content.height
	self.view.content:insert(self.view.content.dialog)
	
	self:showArrow()
	self:showFaces()
end

----------------------------------------------------------
function scene:showPuzzle()
	self.view.content.puzzle = LettersPuzzleClass.new({ layer = self.view.content.puzzle, text = "NEVER", onComplete = function() p("DONE") end })
	self.view.content:insert(self.view.content.puzzle.view)
	self.view.content.puzzle.view.anchorY = 0
	self.view.content.puzzle.view.x = Game.centerX
	self.view.content.puzzle.view.y = 0
end

----------------------------------------------------------
function scene:showBackground()
	self.view.content.bg = display.newRect(self.view.content, Game.centerX, 0, Game.w, Game.h * 8.5)
	self.view.content.bg.anchorY = 0
	self.view.content.bg:setFillColor(0)
end

----------------------------------------------------------
function scene:createScene(event)
	self.timers = {}
	self.transitions = {}
	self.camera = require("lib.camera").new()

	self.view.content = display.newGroup()
	self.view.ui = display.newGroup()
	self.view:insert(self.view.ui)
	self.view:insert(self.view.content)

	self:showBackground()
	self:showDialog()
	self:showPuzzle()
	self.state = "header"
	
	self.camera:init({ layer = self.view, viewable = { xMin = 0, yMin = 0, xMax = Game.w, yMax = self.view.content.height }})

	Runtime:addEventListener("cameraMoved", self)
end

----------------------------------------------------------
function scene:willEnterScene(event)
	self.camera:moveToCenterBottom()
--	self.camera:moveToCenterTop()
end

----------------------------------------------------------
function scene:exitScene(event)
	Runtime:removeEventListener("cameraMoved", self)

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
scene:addEventListener("createScene", scene)
scene:addEventListener("willEnterScene", scene)
scene:addEventListener("exitScene", scene)

return scene