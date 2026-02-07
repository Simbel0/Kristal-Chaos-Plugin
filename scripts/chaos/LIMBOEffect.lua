local LIMBOEffect, super = Class(ChaosEffect, "LIMBO_effect")

function LIMBOEffect:init()
	super.init(self)
	if not Chaos:getAsset("limbo") then
		Chaos:registerAsset("limbo", Music("limbo"))
	end
	self.duration = math.huge

	self.dead_timer = 20
	self.yourealreadydead = false
end

function LIMBOEffect:update()
	if self.yourealreadydead then
		self.dead_timer = self.dead_timer - DTMULT
		if self.dead_timer <= 0 then
			self:stopEffect()
			Game:gameOver()
		end
		return
	end

	if not self.handler or (self.handler and self.handler:isRemoved()) then
		self:stopEffect()
		return
	end

	if self.handler:hasFailed() then
		self.handler:explode():setScale(20,20)
		self.yourealreadydead = true
	elseif self.handler:hasSucceeded() then
		self:stopEffect()
	end
end

function LIMBOEffect:onEffectStart(in_battle)
	self.handler = Game.stage:addChild(LIMBO())
	self.handler:setLayer(999999)
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