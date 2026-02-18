local PlayerSeizureEffect, super = Class(ChaosEffect, "playerSeizure_effect")

function PlayerSeizureEffect:init()
	super.init(self)
	self.duration = MathUtils.random(15, 20)
end

function PlayerSeizureEffect:update()
	local x, y = Game.world.player:getPosition()
	Game.world.player:setPosition(x+Utils.random(-10, 10), y+Utils.random(-10, 10))
end

function PlayerSeizureEffect:canRunEffect()
	return not Game.battle and (Game.world and Game.world.player)
end

return PlayerSeizureEffect