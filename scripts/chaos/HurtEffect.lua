local HurtEffect, super = Class(ChaosEffect, "hurt_effect")

function HurtEffect:onEffectStart(in_battle)
	if in_battle then
        Game.battle:hurt(Utils.random(1, 100), true, "ALL")
    else
        Game.world:hurtParty(Utils.random(1, 100))
    end
end

return HurtEffect