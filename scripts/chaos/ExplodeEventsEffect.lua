local ExplodeEventsEffect, super = Class(ChaosEffect, "eplodeEvents_effect")

function ExplodeEventsEffect:onEffectStart(in_battle)
	local objects = TableUtils.mergeMany(Game.world.stage:getObjects(Character), Game.world.stage:getObjects(Event))

    for i,v in ipairs(objects) do
        if v ~= Game.world.player then
            v:explode()
        end
    end
end

function ExplodeEventsEffect:canRunEffect()
	return Game.world and Game.world.stage
end

return ExplodeEventsEffect