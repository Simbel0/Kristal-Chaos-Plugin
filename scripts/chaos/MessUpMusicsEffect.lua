local MessUpMusicsEffect, super = Class(ChaosEffect, "shuffleMusics_effect")

function MessUpMusicsEffect:onEffectStart(in_battle)
	table.shuffle(Assets.data.music, love.math.random(2, 10))
end

return MessUpMusicsEffect