local ReverseLoveEffect, super = Class(ChaosEffect, "reverseLOVE_effect")

function ReverseLoveEffect:onEffectStart(in_battle)
	love.update(-1)
end

return ReverseLoveEffect