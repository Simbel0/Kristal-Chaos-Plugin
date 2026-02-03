local Plugin = {}
Registry.registerGlobal("Chaos", Plugin)

Plugin.Utils = {}

table.shuffle = function(tbl, amount)
    if not Utils.isArray(tbl) then
        local values = {}
        for k,v in pairs(tbl) do
            table.insert(values, v)
        end
        table.shuffle(values, (amount or 5))
        for k,v in pairs(tbl) do
            tbl[k] = table.remove(values, love.math.random(1, #values))
        end
    else
        for _=1,(amount or 5) do
            for i = #tbl, 2, -1 do
                local j = math.random(i)
                tbl[i], tbl[j] = tbl[j], tbl[i]
            end
        end
    end
    return tbl
end

-- I'm pretty sure this is incorrect, as dicts are not sorted. So for the same index, this function could return different values of the dict
-- But in this case it doesn't matter since it's only used in a *random* function
function Plugin.Utils:getValueFromIndexInDict(dict, index, get_value)
    local i = 0
    for k,v in pairs(dict) do
        i = i+1
        if i == index then
            return get_value and v or k
        end
    end
end

function Plugin.Utils:randomNotArray(tbl, get_value)
    if get_value == nil then get_value = true end
    local max = 0
    for k,v in pairs(tbl) do
        max = max + 1
    end
    local r = love.math.random(1, max)
    return self:getValueFromIndexInDict(tbl, r, get_value)
end

function Plugin.Utils:isRecursiveParent(obj1, obj2)
    if obj1 == obj2 then return false end
    if not obj1.parent then return false end

    if obj1.parent == obj2 then
        return true
    end

    return self:isRecursiveParent(obj1.parent, obj2)
end

-- Game.world.stage and Game.battle.stage are the same so we gotta separate the objects manually
function Plugin.Utils:getObjectsOfCorrectStage(class)
    local objects = Game.world.stage:getObjects(class)
    local stage = Game.battle or Game.world or Game.stage

    local correct_objects = {}
    for i,obj in ipairs(objects) do
        if self:isRecursiveParent(obj, stage) then
            table.insert(correct_objects, obj)
        end
    end

    return correct_objects
end

function Plugin:registerAsset(id, asset, replace)
    if self.registry[id] and not replace then return end
    self.registry[id] = asset
end

function Plugin:getAsset(id)
    return self.registry[id]
end

function Plugin:emptyRegistry()
    for k,v in pairs(self.registry) do
        -- Handles LÖVE2D objects
        if type(v) == "userdata" and v.release then
            v:release()
        -- Handles Kristal classes
        elseif type(v) == "table" and isClass(v) then
            v:remove()
        end
    end
    TableUtils.clear(self.registry)
end

function Plugin:init()
    self.print("init")

    self.registry = {}

    self.timer = Utils.random(60, 600)

    self.debugStopChaos = false

    self.FRAMERATE = FRAMERATE

    self.chaos_effects = {}
    self.active_chaos = {}

    -- Possibly dangerous af but also needed as unload isn't called when an error occurs apparently??
    -- Some effect could leave huge modofications behind after a crash so unloading the plugin is just critical
    Utils.hook(Kristal, "errorHandler", function(orig, ...)
        local ok, err = pcall(self.unload, self)
        if ok then
            self.print("A crash occurred!! Chaos Plugin was able to unload itself")
        else
            self.print("A crash occurred!! Chaos Plugin met an error trying to unload itself: "..err)
        end
        return orig(...)
    end)

    Utils.hook(Utils, "unhook", function(_, target, name)
        for i, hook in ipairs(Utils.__MOD_HOOKS) do
            if hook.target == target and hook.name == name then
                hook.target[hook.name] = hook.orig
                table.remove(Utils.__MOD_HOOKS, i)
                return true
            end
        end
    end)

    for path, name, effect in Registry.iterScripts("chaos", true) do
        if effect == nil then
            local _, path_end = path:find("chaos/")
            local error_path = (path_end and '"chaos/' .. path:sub(path_end+1) .. '.lua"' or '"'..path..'.lua"')
            error(error_path.." does not return value")
        end

        local id = effect.id or name
        self.chaos_effects[id] = effect
    end
end

--[[function Plugin:postLoad()    
    self.overlap_musics = {}
    --self.saveSound = Assets.newSound("save")

    self.event_follow_player = nil
    self.event_glued_player = nil
    self.player_attraction = false
    self.player_attraction_timer = nil
    self.assets_sound_spam_timer = nil

    self.print("Loaded!")
end]]

function Plugin:unload()
    for i,v in ipairs(self.active_chaos) do
        v:onEffectEnd(true)
    end
    TableUtils.clear(self.chaos_effects)
    self:emptyRegistry()

    FRAMERATE = self.FRAMERATE or Kristal.Config["fps"]
    SCREEN_WIDTH = 640
    SCREEN_HEIGHT = 480

    self.print("Unloaded!")
end

--[[function Plugin:onKeyPressed(key)
    if Input.ctrl() and key == "s" then
        Game:saveQuick()
        self.saveSound:play()
        self.print("The game has been temporarely saved! Use Ctrl+R to reload the mod!")
        return true
    end
end]]

function Plugin:postUpdate()
    --print(self.timer)
    if self.debugStopChaos then return end
    self.timer = self.timer - DTMULT

    if self.timer <= 0 then
        self:sillyTime()
        self.timer = Utils.random(60, 600)
    end

    for i=#self.active_chaos, 1, -1 do
        local effect = self.active_chaos[i]
        effect:update()

        effect.duration = effect.duration - (DTMULT / self.FRAMERATE)
        if effect.duration <= 0 then
            self.print("Removing effect "..effect.id)
            effect:onEffectEnd()
            table.remove(self.active_chaos, i)
        end
    end

    --[[if self.event_glued_player then
        self.event_glued_player:setPosition(self.event_glued_player:getPosition())
    end

    if self.player_attraction then
        local objects = Game.world.stage:getObjects(Character)
        for i,v in ipairs(Game.world.stage:getObjects(Event)) do
            if not v:includes(Transition) then
                table.insert(objects, v)
            end
        end
        for i,obj in ipairs(objects) do
            objects[i].x = Utils.approach(obj.x, Game.world.player.x, 2*DTMULT)
            objects[i].y = Utils.approach(obj.y, Game.world.player.y, 2*DTMULT)
        end
    end]]
end

function Plugin.print(msg)
    msg = "[Chaos Plugin] "..msg
    Kristal.Console:push("[color:#00ff00]"..msg)
    print(msg)
end

function Plugin:forceChaos(id)
    self:sillyTime(id)
end

function Plugin:getEffectIDs()
    return TableUtils.getKeys(self.chaos_effects)
end

function Plugin:toggleChaos()
    self.debugStopChaos = not self.debugStopChaos
    self.print((self.debugStopChaos and "Stopped" or "Started").." the chaos!")
end

function Plugin:getChaosEffect(id)
    return self.chaos_effects[id]
end

function Plugin:getRandomChaosEffect()
    local possible_chaos = self:getEffectIDs()
    local function random()
        return self:getChaosEffect(TableUtils.removeValue(possible_chaos, TableUtils.pick(possible_chaos)))
    end

    local effect = random()
    while not effect():canRunEffect() do
        if #possible_chaos == 0 then
            return nil
        end
        effect = random()
    end
    return effect
end

function Plugin:sillyTime(effect_id)
    if effect_id then
        assert(type(effect_id) == "string", "The provided id is invalid. Expected string, got "..type(effect_id)..".")
    end

    local effect = effect_id and self:getChaosEffect(effect_id) or self:getRandomChaosEffect()
    if not effect then
        self.print("No chaos effect is available in the current conditions!")
        return
    end
    effect = effect()
    self.print("Selected effect "..effect.id)

    table.insert(self.active_chaos, effect)
    effect:onEffectStart(Game.battle ~= nil)
end

function Plugin:_old__sillyTime(forceeffect)
    local rand = forceeffect or love.math.random(1, 37)
    self.print("Got effect "..rand)
    if rand == 13 then
        local min_dist = math.huge
        local curr_event = nil
        if not Game.world or not Game.world.stage then
            return
        end
        for i,event in ipairs(Game.world.stage:getObjects(Event)) do
            local event_dist = Utils.dist(event.x, event.y, Game.world.player.x, Game.world.player.y)
            if not (self.event_follow_player == event or self.event_glued_player == event) and event_dist <= min_dist then
                min_dist = event_dist
                curr_event = event
            end
        end

        if curr_event == nil then
            return
        end

        self.event_follow_player = curr_event

        Utils.hook(Player, "move", function(orig, self, x, y, speed, keep_facing)
            orig(self, x, y, speed, keep_facing)
            curr_event:move(x, y, speed)
        end)
        self.Timer:after(Utils.random(1, 10), function()
            Utils.unhook(Player, "move")
            self.event_follow_player = nil
        end)
    elseif rand == 14 then
        local min_dist = math.huge
        local curr_event = nil
        if not Game.world or not Game.world.stage then
            return
        end
        for i,event in ipairs(Game.world.stage:getObjects(Event)) do
            local event_dist = Utils.dist(event.x, event.y, Game.world.player.x, Game.world.player.y)
            if event_dist <= min_dist then
                min_dist = event_dist
                curr_event = event
            end
        end

        if curr_event == nil then
            return
        end

        self.event_glued_player = curr_event
        self.Timer:after(Utils.random(1, 10), function()
            self.event_glued_player = nil
        end)
    elseif rand == 16 then -- Pop out or in of existance the player
        if Game.battle then
            if Game.battle.soul then
                Game.battle.soul.alpha = Game.battle.soul.alpha == 1 and 0 or 1
            else
                Game.battle.party[1].alpha = Game.battle.party[1].alpha == 1 and 0 or 1
            end
        end
        Game.world.player.alpha = Game.world.player.alpha == 1 and 0 or 1
    elseif rand == 17 then -- Kris on drugs
        self.Timer:every(1/30, function()
            local x, y = Game.world.player:getPosition()
            Game.world.player:setPosition(x+Utils.random(-10, 10), y+Utils.random(-10, 10))
        end, 500)
    elseif rand == 18 then
        local objects = Game.world.stage:getObjects(Character)
        for i,v in ipairs(Game.world.stage:getObjects(Event)) do
            table.insert(objects, v)
        end
        Game.world.camera.target = objects[love.math.random(1, #objects)]
        self.Timer:after(Utils.random(1, 10), function()
            Game.world.camera.target = Game.world.player
        end)
    elseif rand == 21 then
        for i=#Game.party, 2, -1 do
            Game:removePartyMember(Game.party[i])
        end
    elseif rand == 27 then
        local id = Game.party[love.math.random(1, #Game.party)].id
        local chara = Game.world:getCharacter(id)
        if Game.battle then
            chara = Game.battle:getPartyBattler(id)
        end
        chara.sprite.flip_x = not chara.sprite.flip_x
        chara.sprite.flip_y = not chara.sprite.flip_y
    elseif rand == 30 then
        if self.player_attraction_timer then
            self.Timer:cancel(self.player_attraction_timer)
        end
        self.player_attraction = true
        self.player_attraction_timer = self.Timer:after(Utils.random(1, 10), function()
            self.player_attraction = false
            self.player_attraction_timer = nil
        end)
    elseif rand == 31 then
        local sprites = GetObjectsOfCorrectStage(Sprite) --Game.world.stage:getObjects(Sprite)
        local sprite = sprites[love.math.random(1, #sprites)]
        sprite.scale_x = Utils.random(-5, 5)
        sprite.scale_y = Utils.random(-5, 5)
    elseif rand == 32 then
        if #Game.world.map.tile_layers > 0 then
            for i=1,Game.world.map.width*40+Game.world.map.height*40 do
                Game.world.map:setTile(love.math.random(Game.world.map.width*40), love.math.random(Game.world.map.height*40), love.math.random(0, 924))
            end
        end
    elseif rand == 33 then
        local actor = randomNotArray(Registry.actors, false)
        Game.world.player:setActor(actor)
        if Game.battle then
            --Game.battle:getPartyBattler(Game.world.player.actor.id):setActor(actor)
        end
    elseif rand == 34 then
        if self.assets_sound_spam_timer then
            self.Timer:cancel(self.assets_sound_spam_timer)
        end
        self.assets_sound_spam_timer = self.Timer:every(1/20, function()
            Assets.playSound(randomNotArray(Assets.sounds, false), 0.1, 1)
        end, 500)
    elseif rand == 36 then
        local off_x = Utils.random(-100, 100)
        local off_y = Utils.random(-100, 100)
        for i,collider in ipairs(Game.world.map.collision) do
            collider.x = collider.x+off_x
            collider.y = collider.y+off_y
        end
    elseif rand == 37 then
        for i,collider in ipairs(Game.world.map.collision) do
            local off_x = Utils.random(-100, 100)
            local off_y = Utils.random(-100, 100)

            collider.x = collider.x+off_x
            collider.y = collider.y+off_y
        end
    end
end

return Plugin