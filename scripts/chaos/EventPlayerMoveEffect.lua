local EventPlayerMoveEffect, super = Class(ChaosEffect, "eventFollowPlayer_effect")

function EventPlayerMoveEffect:init()
	super.init(self)
	self.duration = Utils.random(1, 10)
	self.event = nil
end

function EventPlayerMoveEffect:onEffectStart(in_battle)
	local min_dist = math.huge
    local curr_event = nil
    local already_moved_events = {}
    for i,effect in ipairs(TableUtils.mergeMany(
    	Chaos:getActiveEffectsOfID(self.id),
    	Chaos:getActiveEffectsOfID("eventApproachesPlayer_effect")
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

    self.player_x, self.player_y = Game.world.player:getPosition()
end

function EventPlayerMoveEffect:update()
	local x, y = self.event:getPosition()

	local player = Game.world.player
	local pX, pY = player:getPosition()

	local diff_player_x = pX - self.player_x
	local diff_player_y = pY - self.player_y

	self.event:setPosition(x+diff_player_x, y+diff_player_y)

	self.player_x = pX
	self.player_y = pY
end

function EventPlayerMoveEffect:canRunEffect()
	return Game.world and Game.world.stage and Game.world.player
end

return EventPlayerMoveEffect