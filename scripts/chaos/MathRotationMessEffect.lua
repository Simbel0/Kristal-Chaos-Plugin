local MathRotationMessEffect, super = Class(ChaosEffect, "fuckRotation_effect")

function MathRotationMessEffect:init()
	super.init(self)
	self.duration = math.huge
end

function MathRotationMessEffect:onEffectStart(in_battle)
	self.old_rad = math.rad
	self.old_deg = math.deg
	math.rad = self.old_deg
	math.deg = self.old_rad
end

function MathRotationMessEffect:onEffectEnd()
	math.rad = self.old_rad
	math.deg = self.old_deg
end

function MathRotationMessEffect:canRunEffect()
	return #Chaos:getActiveEffectsOfID(self.id) == 0
end

return MathRotationMessEffect