-- Copyright 2013 Arman Darini

local class = {}
class.new = function(o)
	local GameClass = {
		debug = false,
		w = display.contentWidth,
		h = display.contentHeight,
		centerX = display.contentCenterX,
		centerY = display.contentCenterY,
--		font = "AveriaLibre-Bold",
		font = "Cabin-Regular",
		fontBold = "Cabin-Bold",
		fontItalic = "Cabin-Italic",
		controlsBlocked = false,
		level = 1,
		levelCompleted = false,
	}

	----------------------------------------------------------
	function GameClass:init(o)
		return self
	end

	----------------------------------------------------------
	function GameClass:removeSelf()
	end

	----------------------------------------------------------
	GameClass:init(o)

	return GameClass
end

return class
