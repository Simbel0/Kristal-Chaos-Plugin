local RandomMercyEffect, super = Class(ChaosEffect, "mercy_effect")

function RandomMercyEffect:onEffectStart(in_battle)
	TableUtils.pick(Game.battle:getActiveEnemies()):addMercy(love.math.random(-100, 100))
end

function RandomMercyEffect:canRunEffect()
	return Game.battle and #Game.battle:getActiveEnemies() > 0
end

return RandomMercyEffect