local PressOrDieEffect, super = Class(ChaosEffect, "pressordie_effect")

function PressOrDieEffect:init()
	super.init(self)
	self.duration = math.huge
end

function PressOrDieEffect:update()
	if not self.handler or (self.handler and self.handler:isRemoved()) then
		self:stopEffect()
		return
	end

	if self.handler:hasFailed() then
		Game:gameOver()
		self:stopEffect()
	elseif self.handler:hasSucceeded() then
		self:stopEffect()
	end
end

function PressOrDieEffect:onEffectStart(in_battle)
	Input.clear()
	self.handler = Game.stage:addChild(PressOrDie())
end

function PressOrDieEffect:onEffectEnd()
	if self.handler then
		self.handler:remove()
	end
end

function PressOrDieEffect:canRunEffect()
	return #Chaos:getActiveEffectsOfID(self.id) == 0 and not Input.usingGamepad() -- fuck it
end

return PressOrDieEffect