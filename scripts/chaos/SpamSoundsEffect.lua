local SpamSoundsEffect, super = Class(ChaosEffect, "spamSnd_effect")

function SpamSoundsEffect:init()
	super.init(self)
	self.duration = math.huge
end

function SpamSoundsEffect:onEffectStart(in_battle)
	self.timer = 0
	self.max_timer = 1/20
	self.count = love.math.random(200, 500)
end

function SpamSoundsEffect:update()
	self.timer = self.timer + DTMULT/Chaos.FRAMERATE
	if self.timer > self.max_timer then
		Assets.playSound(Chaos.Utils:randomNotArray(Assets.sounds, false), 0.1, 1)
		self.timer = 0
		self.count = self.count - 1
		if self.count <= 0 then
			self:stopEffect()
		end
	end
end

return SpamSoundsEffect