local NoMoreControlEffect, super = Class(ChaosEffect, "nomove_effect")

function NoMoreControlEffect:init()
	self.duration = Utils.random(1, 10)
end

function NoMoreControlEffect:onEffectStart(in_battle)
	if in_battle and Game.battle.soul then
		self.moving_object = Game.battle.soul
	else
		self.moving_object = Game.world.player
	end
	self.orig_move = self.moving_object.move
	self.moving_object.move = function() end
end

function NoMoreControlEffect:update()
	-- If case the soul is the object, the wave could end before the effect ends and remove the soul
	if not self.moving_object or self.moving_object:isRemoved() then
		self:stopEffect()
	end
end

function NoMoreControlEffect:onEffectEnd()
	if self.moving_object and not self.moving_object:isRemoved() then
		self.moving_object.move = self.orig_move
	end
	self.moving_object = nil
end

function NoMoreControlEffect:canRunEffect()
	if Game.battle then
		return Game.battle.soul
	end
	return true
end

return NoMoreControlEffect