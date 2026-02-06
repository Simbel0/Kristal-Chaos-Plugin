local ChangePlayerActorEffect, super = Class(ChaosEffect, "changePlayerActor_effect")

function ChangePlayerActorEffect:onEffectStart(in_battle)
	local actor = Chaos.Utils:randomNotArray(Registry.actors, false)
    Game.world.player:setActor(actor)

    if in_battle then
	    local anims = TableUtils.getValues(Registry.createActor(actor).animations)
	    local is_battle_actor = TableUtils.some(anims, function(anim)
		    if type(anim) == "table" then
		        anim = anim[1]
		    end
		    return anim:find("battle")
		end)
	    if is_battle_actor then
	        Game.battle:getPartyBattler(Game.party[1].id):setActor(actor)
	    end
	end
end

function ChangePlayerActorEffect:canRunEffect()
	return Game.world and Game.world.player
end

return ChangePlayerActorEffect