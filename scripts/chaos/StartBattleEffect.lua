local StartBattleEffect, super = Class(ChaosEffect, "battle_effect")

function StartBattleEffect:onEffectStart(in_battle)
	if in_battle then
		Chaos.Utils:randomNotArray(Registry.encounters)()
	else
		Game:encounter(Chaos.Utils:randomNotArray(Registry.encounters, false))
	end
end

return StartBattleEffect