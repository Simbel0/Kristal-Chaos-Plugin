local StartBattleEffect, super = Class(ChaosEffect, "battle_effect")

function StartBattleEffect:onEffectStart(in_battle)
	if in_battle then
		randomNotArray(Registry.encounters)()
	else
		Game:encounter(randomNotArray(Registry.encounters, false))
	end
end

return StartBattleEffect