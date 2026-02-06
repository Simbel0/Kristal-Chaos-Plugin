local FlipPartyMemberEffect, super = Class(ChaosEffect, "flipParty_effect")

function FlipPartyMemberEffect:onEffectStart(in_battle)
	local id = Game.party[love.math.random(1, #Game.party)].id
    local chara = Game.world:getCharacter(id)
    if Game.battle then
        chara = Game.battle:getPartyBattler(id)
    end
    chara.sprite.flip_x = not chara.sprite.flip_x
    chara.sprite.flip_y = not chara.sprite.flip_y
end

function FlipPartyMemberEffect:canRunEffect()
	return (Game.world.stage or Game.battle.stage) and #Game.party > 0
end

return FlipPartyMemberEffect