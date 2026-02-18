local RandomAssExplosionEffect, super = Class(ChaosEffect, "explosion_effect")

function RandomAssExplosionEffect:onEffectStart(in_battle)
	local e = Explosion(Utils.random(0, SCREEN_WIDTH), Utils.random(SCREEN_HEIGHT))
	e.layer = MathUtils.randomInt(0, 1000)

	local parent = Game.battle or Game.world
	if not parent.stage then
		parent = Game.stage
	end
	parent:addChild(e)
end

return RandomAssExplosionEffect