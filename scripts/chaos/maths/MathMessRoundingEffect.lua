local MathMessRoundingEffect, super = Class(ChaosEffect, "roundingMess_effect")

function MathMessRoundingEffect:init()
	super.init(self)
	self.duration = math.huge
end

function MathMessRoundingEffect:onEffectStart(in_battle)
	self.orig = {
		ceil = math.ceil,
		floor = math.floor
	}
	math.floor = self.orig.ceil
	math.ceil = self.orig.floor
end

function MathMessRoundingEffect:onEffectEnd()
	math.floor = self.orig.floor
	math.ceil = self.orig.ceil
end

function MathMessRoundingEffect:canRunEffect()
	return #Chaos:getActiveEffectsOfID(self.id) == 0
end

return MathMessRoundingEffect