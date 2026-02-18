local NoMoreCheckEffect, super = Class(ChaosEffect, "noCheck_effect")

function NoMoreCheckEffect:onEffectStart(in_battle)
	for i,enemy in ipairs(Game.battle.enemies) do
		TableUtils.filterInPlace(enemy.acts, function(v) return v.name ~= "Check" end)
	end
end

function NoMoreCheckEffect:canRunEffect()
	return Game.battle and #Game.battle.enemies > 0
end

return NoMoreCheckEffect