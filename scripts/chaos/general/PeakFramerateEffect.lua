local PeakFramerateEffect, super = Class(ChaosEffect, "badFPS_effect")

function PeakFramerateEffect:init()
	self.duration = Utils.random(1, 10)
	self.old_framerate = FRAMERATE
end

function PeakFramerateEffect:onEffectStart(in_battle)
	FRAMERATE = 3
end

function PeakFramerateEffect:onEffectEnd()
	FRAMERATE = self.old_framerate
end

return PeakFramerateEffect