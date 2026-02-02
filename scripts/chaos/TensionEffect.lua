local TensionEffect, super = Class(ChaosEffect, "tension_effect")

function TensionEffect:onEffectStart(in_battle)
	Game:giveTension(love.math.random(0, 200))
end

return TensionEffect