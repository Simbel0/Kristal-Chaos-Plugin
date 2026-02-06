local LIMBOEffect, super = Class(ChaosEffect, "LIMBO_effect")

function LIMBOEffect:init()
	super.init(self)
	if not Chaos:getAsset("limbo") then
		Chaos:registerAsset("limbo", Music("limbo"))
	end
	self.duration = math.huge
end

function LIMBOEffect:onEffectStart(in_battle)
	self.handler = Game.stage:addChild(LIMBO())
end

function LIMBOEffect:onEffectEnd()
	if self.handler then
		self.handler:remove()
	end
end

function LIMBOEffect:canRunEffect()
	return #Chaos:getActiveEffectsOfID(self.id) == 0
end

return LIMBOEffect