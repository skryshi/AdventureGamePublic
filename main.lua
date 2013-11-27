-- Copyright 2013 Arman Darini

display.setStatusBar(display.HiddenStatusBar)

-- these are used almost everywhere, so make they global
Utils = require("lib.utils")
Math = require("lib.math2")
Helpers = require("lib.helpers")
Widget = require("widget")
Json = require("json")
Storyboard = require("storyboard")
Storyboard.purgeOnSceneChange = true

Game = require("game.game").new()
User = require("game.user").new()

--	init sounds and music
Sounds = {
	click = audio.loadSound("assets/sounds/click.mp3"),
	doctorSpeech1 = audio.loadSound("assets/sounds/doctor_speech1.mp3"),
	doctorSpeech2 = audio.loadSound("assets/sounds/doctor_speech2.mp3"),
	heartBeat = audio.loadSound("assets/sounds/heart_beat.mp3"),
	face = {
		["face01"] = audio.loadSound("assets/sounds/face_speech1.mp3"),
		["face02"] = audio.loadSound("assets/sounds/face_speech2.mp3"),
		["face03"] = audio.loadSound("assets/sounds/face_speech3.mp3"),
		["face04"] = audio.loadSound("assets/sounds/face_speech4.mp3"),
	}
}
--Music = audio.loadStream("sounds/theme_song.mp3")
--audio.play(Music, { channel = 2, loops=-1, fadein=1000 })

-- add debug
if Game.debug then
	timer.performWithDelay(1000, Utils.printMemoryUsed, 0)
end

Storyboard.gotoScene("game.scenes.intro", { params = {} })
--Storyboard.gotoScene("game.scenes.waking_up", { params = {} })