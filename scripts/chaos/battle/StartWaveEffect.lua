local StartWaveEffect, super = Class(ChaosEffect, "randomwave_effect")

function StartWaveEffect:onEffectStart(in_battle)
	local enemy = TableUtils.pick(Game.battle.enemies)
	local wave = TableUtils.pick(enemy.waves)

	if Game.battle:hasCutscene() then
		Game.battle.cutscene:endCutscene()
	end

	Game.battle:setState("DEFENDINGBEGIN", { wave })
end

function StartWaveEffect:canRunEffect()
	return Game.battle and #Game.battle.enemies > 0
end

return StartWaveEffect