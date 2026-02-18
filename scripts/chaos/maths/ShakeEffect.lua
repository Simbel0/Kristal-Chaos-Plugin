local ShakeEffect, super = Class(ChaosEffect, "shake_effect")

function ShakeEffect:onEffectStart(in_battle)
	Game.stage:shake(Utils.random(10, 100), Utils.random(10, 100), Utils.random(), Utils.random(1/30, 1))
end

function ShakeEffect:canRunEffect()
    return Game.stage ~= nil
end

return ShakeEffect