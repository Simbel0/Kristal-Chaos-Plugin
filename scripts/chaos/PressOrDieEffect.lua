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

	--Chaos.print(self.handler:hasFailed(), self.handler:hasSucceeded(), self.handler.success)
	if self.handler:hasFailed() then
		print("Lost.")
		Game:gameOver()
		self:stopEffect()
	elseif self.handler:hasSucceeded() then
		print("Won.")
		self:stopEffect()
	end
end

function PressOrDieEffect:onEffectStart(in_battle)
	Input.clear()
	self.handler = Game.stage:addChild(PressOrDie())
	Chaos:trackInputs(self.handler)
end

function PressOrDieEffect:onEffectEnd()
	print("Stop PressOrDie")
	if self.handler then
		Chaos:stopTrackInputs(self.handler)
		self.handler:remove()
	end
end

return PressOrDieEffect