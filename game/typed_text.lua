-- Copyright 2013 Arman Darini

local class = {}
class.new = function(o)
	local TypedTextClass = {}
	TypedTextClass.parent = nil
	TypedTextClass.view = nil
	TypedTextClass.timers = {}
	TypedTextClass.transitions = {}
	TypedTextClass.text = ""

	----------------------------------------------------------
	function TypedTextClass:init(o)
		self.view = display.newText(o)
		self.parent = o.parent
		self.text = o.text
		self.view.text = ""
		self.view.owner = self
		return self
	end

	----------------------------------------------------------
	function TypedTextClass:typeLetters(speed)
		local i, j = self.text:find(self.view.text)
		if j == self.text:len() then
			return
		end
		self.view.text = self.text:sub(i, j + 1)
		if "..." == self.view.text:sub(-3) then
			timer.performWithDelay(5 * speed, function() self:typeLetters(speed) end)
		elseif "." == self.view.text:sub(-1) then
			timer.performWithDelay(20 * speed, function() self:typeLetters(speed) end)
		else
			timer.performWithDelay(speed, function() self:typeLetters(speed) end)
		end
	end
	
	----------------------------------------------------------
	function TypedTextClass:typeWords(speed)
		local _, i = self.text:find(self.view.text)
		if i == self.text:len() then
			return
		end
		local j, _ = self.text:find(" ", i + 1)
		if nil == j then
			j = self.text:len()
		end
		self.view.text = self.text:sub(1, j)
		timer.performWithDelay(math.random(1, 2 * speed), function() self:typeWords(speed) end)
	end
	
	----------------------------------------------------------
	function TypedTextClass:removeSelf()
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
	TypedTextClass:init(o)

	return TypedTextClass
end

return class
