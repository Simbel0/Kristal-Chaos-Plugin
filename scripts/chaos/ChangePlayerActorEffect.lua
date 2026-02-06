local ChangePlayerActorEffect, super = Class(ChaosEffect, "changePlayerActor_effect")

function ChangePlayerActorEffect:onEffectStart(in_battle)
	local actor = Chaos.Utils:randomNotArray(Registry.actors, false)
    Game.world.player:setActor(actor)

    local anims = TableUtils.getValues(Registry.createActor(actor).animations)
    local is_battle_actor = TableUtils.some(anims, function(anim)
	    if type(anim) == "table" then
	        anim = anim[1]
	    end
	    return anim:find("battle")
	end)
    if in_battle and is_battle_actor then
        Game.battle:getPartyBattler(Game.party[1].id):setActor(actor)
    end
end

return ChangePlayerActorEffect