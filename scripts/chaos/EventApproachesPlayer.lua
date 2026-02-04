local EventApproachesPlayerEffect, super = Class(ChaosEffect, "eventApproachesPlayer_effect")

function EventApproachesPlayerEffect:init()
	super.init(self)
	self.duration = Utils.random(1, 10)
	self.event = nil
end

function EventApproachesPlayerEffect:onEffectStart(in_battle)
	local min_dist = math.huge
    local curr_event = nil
    local already_moved_events = {}
    for i,effect in ipairs(TableUtils.mergeMany(
    	Chaos:getActiveEffectsOfID(self.id),
    	Chaos:getActiveEffectsOfID("eventFollowPlayer_effect")
    )) do
    	table.insert(already_moved_events, effect.event)
    end

    for i,event in ipairs(Game.world.stage:getObjects(Event)) do
        local event_dist = Utils.dist(event.x, event.y, Game.world.player.x, Game.world.player.y)
        if not TableUtils.contains(already_moved_events, event) and event_dist <= min_dist then
            min_dist = event_dist
            curr_event = event
        end
    end

    if curr_event == nil then
    	self:stopEffect()
        return
    end

    self.event = curr_event
end

function EventApproachesPlayerEffect:update()
	local x, y = self.event:getPosition()

	x = MathUtils.approach(x, Game.world.player.x, 2*DTMULT)
	y = MathUtils.approach(y, Game.world.player.y, 2*DTMULT)

	self.event:setPosition(x, y)
end

function EventApproachesPlayerEffect:canRunEffect()
	return Game.world and Game.world.stage and Game.world.player
end

return EventApproachesPlayerEffect