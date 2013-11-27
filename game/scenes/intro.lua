-- Copyright 2013 Arman Darini
local scene = Storyboard.newScene()
local TypedTextClass = require("game.typed_text")

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
function scene:showDoctorsDialog()
	print("showDoctorsDialog")
	self.view:removeEventListener("tap", self)

	self.view.content.dialog = display.newGroup()
	self.view.content.dialog.one = TypedTextClass.new({ parent = self.view.content.dialog, text = "- ... increase the dosage again. His body adapts faster every time. I wish ... open his brain and take a look inside ... Nobel prize ...", x = 0, y = 0, width = Game.w - 50, height = 0, font = Game.font, fontSize = 15 }).view
--	self.view.content.dialog.one = display.newText(self.view.content.dialog, "- ... increase the dosage again. His body adapts faster every time. I wish ... open his brain and take a look inside ... Nobel prize ...", 0, 0, Game.w - 50, 0, Game.font, 15)
	self.view.content.dialog.one.anchorY = 0
	self.view.content.dialog.one.x = Game.centerX
	self.view.content.dialog.one.y = Game.centerY - 100
	self.view.content.dialog.one:setFillColor(1)
	timer.performWithDelay(1400, function() audio.play(Sounds.doctorSpeech1, { channel = 1 }) end)
	self.view.content.dialog.one.owner:typeLetters(38)

	self.view.content.dialog.two = TypedTextClass.new({ parent = self.view.content.dialog, text = "- You just might get an opportunity soon ... is coming ...", x = 0, y = 0, width = Game.w - 50, height = 0, font = Game.font, fontSize = 15 }).view
--	self.view.content.dialog.two = display.newText(self.view.content.dialog, "- You just might get an opportunity soon ... is coming ...", 0, 0, Game.w - 50, 0, Game.font, 15)
	self.view.content.dialog.two.anchorY = 0
	self.view.content.dialog.two.x = Game.centerX
	self.view.content.dialog.two.y = Game.centerY + 10
	self.view.content.dialog.two:setFillColor(1)
	timer.performWithDelay(15000, function()
		timer.performWithDelay(0, function() audio.play(Sounds.doctorSpeech2, { channel = 1 }) end)
		self.view.content.dialog.two.owner:typeLetters(40)
	end)

	self.view.content:insert(self.view.content.dialog)
	
	timer.performWithDelay(20000, function() self.view:addEventListener("tap", self) end )
end

----------------------------------------------------------
function scene:hideDoctorsDialog()
	print("hideDoctorsDialog")
	display.remove(self.view.content.dialog)
end

----------------------------------------------------------
function scene:showBlink()
	self.view:removeEventListener("tap", self)

	self.view.content.blink = display.newContainer(Game.w, 0)
	self.view.content.blink.x = Game.centerX
	self.view.content.blink.y = Game.centerY
	
	self.view.content.blink.bg = display.newImageRect(self.view.content.blink, "assets/images/bed_blur.jpg", Game.w, Game.h)
	self.view.content:insert(self.view.content.blink)
	
	local timings = { 1000, 1000, 1500, 1500, 2500, 2500 }
--	local timings = { 100, 100, 150, 150, 250, 250 }
	local heights = { 100, 0, 150, 0, 250, 0 }
	transition.to(self.view.content.blink, { time = timings[1], height = heights[1], onComplete = function() display.remove(self.view.content.header) end })
	transition.to(self.view.content.blink, { time = timings[2], delay = timings[1], height = heights[2] })
	transition.to(self.view.content.blink, { time = timings[3], delay = 1000 + timings[1] + timings[2], height = heights[3] })
	transition.to(self.view.content.blink, { time = timings[4], delay = 1000 + timings[1] + timings[2] + timings[3], height = heights[4] })
	transition.to(self.view.content.blink, { time = timings[5], delay = 2000 + timings[1] + timings[2] + timings[3] + timings[4], height = heights[5] })
	transition.to(self.view.content.blink, { time = timings[6], delay = 2000 + timings[1] + timings[2] + timings[3] + timings[4] + timings[5], height = heights[6], onComplete = function() self:hideBlink() end})

	timer.performWithDelay(0, function() audio.play(Sounds.heartBeat, { channel = 1, duration = timings[1] + timings[2] }) end)
	timer.performWithDelay(1000 + timings[1] + timings[2], function() audio.play(Sounds.heartBeat, { channel = 1, duration = timings[3] + timings[4] }) end)
	timer.performWithDelay(2000 + timings[1] + timings[2] + timings[3] + timings[4], function() audio.play(Sounds.heartBeat, { channel = 1, duration = timings[5] + timings[6] }) end)
end

----------------------------------------------------------
function scene:hideBlink()
	print("hideBlink")
	display.remove(self.view.content.blink)
	self.view:addEventListener("tap", self)
end

----------------------------------------------------------
function scene:showHeader()
	self.view.content.header = display.newGroup()
	self.view.content.header.title = display.newText(self.view.content.header, "ESCAPE", 0, 0, Game.font, 50)
	self.view.content.header.title.x = Game.centerX
	self.view.content.header.title.y = Game.centerY - self.view.content.header.title.height * 0.5
	self.view.content.header.title:setFillColor(1)

	self.view.content.header.subtitle = display.newText(self.view.content.header, "Chapter 1", 0, 0, Game.font, 20)
	self.view.content.header.subtitle.x = Game.centerX
	self.view.content.header.subtitle.y = self.view.content.header.title.y + self.view.content.header.title.height * 0.5
	self.view.content.header.subtitle:setFillColor(1)

	self.view.content:insert(self.view.content.header)
end

----------------------------------------------------------
function scene:showBackground()
	self.view.content.bg = display.newRect(self.view.content, Game.centerX, Game.centerY, Game.w, Game.h)
	self.view.content.bg:setFillColor(0)
end

----------------------------------------------------------
function scene:createScene(event)
	self.timers = {}
	self.transitions = {}

	self.view.content = display.newGroup()
	self.view.ui = display.newGroup()
	self.view:insert(self.view.ui)
	self.view:insert(self.view.content)

	self:showBackground()
	self:showHeader()
	self.state = "header"
	self.view:addEventListener("tap", self)
--	self:showDoctorsDialog()	
end

----------------------------------------------------------
function scene:willEnterScene(event)
end

----------------------------------------------------------
function scene:exitScene(event)
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