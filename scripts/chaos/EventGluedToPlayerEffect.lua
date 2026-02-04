local EventGluedToPlayerEffect, super = Class(ChaosEffect, "eventGluedToPlayer_effect")

function EventGluedToPlayerEffect:init()
	super.init(self)
	self.duration = Utils.random(1, 10)
	self.event = nil
end

function EventGluedToPlayerEffect:onEffectStart(in_battle)
	local min_dist = math.huge
    local curr_event = nil
    local already_glued_events = {}
    for i,effect in ipairs(Chaos:getActiveEffectsOfID(self.id)) do
    	table.insert(already_glued_events, effect.event)
    end

    self.event = TableUtils.pick(
        TableUtils.filter(Game.world.stage:getObjects(Event), function(v)
            return not TableUtils.contains(already_glued_events, v)
        end)
    )

    if self.event == nil then
    	self:stopEffect()
        return
    end
end

function EventGluedToPlayerEffect:update()
	self.event:setPosition(Game.world.player:getPosition())
end

function EventGluedToPlayerEffect:canRunEffect()
	return Game.world and Game.world.stage and Game.world.player
end

return EventGluedToPlayerEffect