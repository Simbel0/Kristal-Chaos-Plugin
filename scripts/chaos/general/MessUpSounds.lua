local MessUpSoundsEffect, super = Class(ChaosEffect, "shuffleSounds_effect")

function MessUpSoundsEffect:onEffectStart(in_battle)
	table.shuffle(Assets.sounds, love.math.random(2, 10))
end

return MessUpSoundsEffect