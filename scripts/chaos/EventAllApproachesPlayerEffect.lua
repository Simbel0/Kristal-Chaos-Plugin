local EventAllApproachesPlayerEffect, super = Class(ChaosEffect, "eventALLApproachesPlayer_effect")

function EventAllApproachesPlayerEffect:init()
    super.init(self)
    self.duration = Utils.random(1, 10)
    self.events = {}
end

function EventAllApproachesPlayerEffect:onEffectStart(in_battle)
    local already_occupied_events = {}
    for i,effect in ipairs(TableUtils.mergeMany(
        Chaos:getActiveEffectsOfID("eventApproachesPlayer_effect"),
        Chaos:getActiveEffectsOfID("eventFollowPlayer_effect"),
        Chaos:getActiveEffectsOfID("eventGluedToPlayer_effect")
    )) do
        table.insert(already_occupied_events, effect.event)
    end

    local objects = TableUtils.mergeMany(
        Game.world.stage:getObjects(Character),
        Game.world.stage:getObjects(Event)
    )
    self.events = TableUtils.filter(objects, function(v)
        return not TableUtils.contains(already_occupied_events, v) and v ~= Game.world.player
    end)

    if not self.events or #self.events == 0 then
        self:stopEffect()
        return
    end
end

function EventAllApproachesPlayerEffect:update()
    for i,obj in ipairs(self.events) do
        self.events[i].x = MathUtils.approach(obj.x, Game.world.player.x, 2*DTMULT)
        self.events[i].y = MathUtils.approach(obj.y, Game.world.player.y, 2*DTMULT)
    end
end

function EventAllApproachesPlayerEffect:canRunEffect()
    return Game.world and Game.world.stage and Game.world.player and #Chaos:getActiveEffectsOfID(self.id) == 0
end

return EventAllApproachesPlayerEffect