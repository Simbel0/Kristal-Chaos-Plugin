local MessWithPiEffect, super = Class(ChaosEffect, "fuckPi_effect")

function MessWithPiEffect:init()
	super.init(self)
	self.duration = math.huge
end

function MessWithPiEffect:onEffectStart(in_battle)
	self.old_pi = math.pi
	math.pi = 4
end

function MessWithPiEffect:onEffectEnd()
	math.pi = self.old_pi
end

function MessWithPiEffect:canRunEffect()
	return #Chaos:getActiveEffectsOfID(self.id) == 0
end

return MessWithPiEffect