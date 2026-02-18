local ShuffleActsEffect, super = Class(ChaosEffect, "shuffleActs_effect")

function ShuffleActsEffect:onEffectStart(in_battle)
	for i,v in ipairs(Game.battle.enemies) do
		table.shuffle(v.acts)
	end
end

function ShuffleActsEffect:canRunEffect()
	return Game.battle and #Game.battle.enemies > 0
end

return ShuffleActsEffect