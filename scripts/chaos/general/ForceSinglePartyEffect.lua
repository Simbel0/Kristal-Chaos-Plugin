local ForceSinglePartyEffect, super = Class(ChaosEffect, "singleOnALonelyNight_effect")

function ForceSinglePartyEffect:onEffectStart(in_battle)
	for i=#Game.party, 2, -1 do
        Game:removePartyMember(Game.party[i])
    end
end

return ForceSinglePartyEffect