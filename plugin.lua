local Plugin = {}

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

local function getValueFromIndexInDict(dict, index, get_value)
    local i = 0
    for k,v in pairs(dict) do
        i = i+1
        if i == index then
            return get_value and v or k
        end
    end
end

local function randomNotArray(tbl, get_value)
    if get_value == nil then get_value = true end
    local max = 0
    for k,v in pairs(tbl) do
        max = max + 1
    end
    local r = love.math.random(1, max)
    return getValueFromIndexInDict(tbl, r, get_value)
end

function Plugin:postLoad()
    print("Loaded !")

    self.mario = love.graphics.newImage("mods/chaos/assets/sprites/mario.png")

    self.timer_nb = Utils.random(60, 600)
    self.Timer = Timer()

    Utils.hook(Utils, "unhook", function(_, target, name)
        for i, hook in ipairs(Utils.__MOD_HOOKS) do
            if hook.target == target and hook.name == name then
                hook.target[hook.name] = hook.orig
                table.remove(Utils.__MOD_HOOKS, i)
                return true
            end
        end
    end)

    self.event_follow_player = nil
    self.event_glued_player = nil
    self.player_attraction = false
    self.player_attraction_timer = nil

    self.decreasesColorShader = love.graphics.newShader([[
        extern vec3 lostcolor;

        vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords )
        {
            vec4 outputcolor = Texel(tex, texture_coords) * color;
            vec3 newcolor = outputcolor.rbg - lostcolor.rgb;
            return vec4(newcolor.r, newcolor.g, newcolor.b, color.a);
        }
    ]])
end

function Plugin:unload()
    if self.old_framerate then
        FRAMERATE = self.old_framerate
    end
end

function Plugin:postUpdate()
    print(self.timer_nb)
    self.Timer:update()
    self.timer_nb = self.timer_nb - DTMULT

    if self.timer_nb <= 0 then
        self:sillyTime()
        self.timer_nb = Utils.random(60, 600)
    end

    if self.event_glued_player then
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
    end
end

function Plugin:sillyTime()
    local rand = love.math.random(33)
    print(rand)
    if rand == 1 then
        Game:gameOver()
    elseif rand == 2 then
        if Game.battle and Game.battle.soul then
            Game.battle.soul.y = Game.battle.soul.y + Utils.random(-50, 50)
            return
        end
        Game.world.player.y = Game.world.player.y + Utils.random(-50, 50)
    elseif rand == 3 then
        SCREEN_WIDTH = Utils.random(10, 640)
    elseif rand == 4 then
        SCREEN_HEIGHT = Utils.random(10, 480)
    elseif rand == 5 then
        Game:giveTension(love.math.random(0, 200))
    elseif rand == 6 then
        self.old_framerate = FRAMERATE
        FRAMERATE = 3
        self.Timer:after(Utils.random(1, 10), function()
            FRAMERATE = self.old_framerate
            self.old_framerate = nil
        end)
    elseif rand == 7 then
        Utils.hook(Player, "move", function(orig, self, x, y, speed, keep_facing)
            orig(self, y, x, speed, keep_facing)
        end)
        self.Timer:after(Utils.random(1, 10), function()
            Utils.unhook(Player, "move")
        end)
    elseif rand == 8 then
        Kristal.Console:open()
    elseif rand == 9 then
        Kristal.DebugSystem:openMenu()
    elseif rand == 10 then
        Game.world:hurtParty(Utils.random(1, 100))
    elseif rand == 11 then
        Game.world.music:setPitch(Utils.random(0, 2))
    elseif rand == 12 then
        Utils.hook(Player, "move", function(orig, self, x, y, speed, keep_facing)
            -- nothing
        end)
        self.Timer:after(Utils.random(1, 10), function()
            Utils.unhook(Player, "move")
        end)
    elseif rand == 13 then
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
    elseif rand == 15 then -- Do some funny shit
        love.update(-5)
    elseif rand == 16 then -- Pop out or in of existance the player
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
    elseif rand == 19 then
        Game.world.camera:setAttached(false)
        self.Timer:after(Utils.random(1, 10), function()
            Game.world.camera:setAttached(true)
        end)
    elseif rand == 20 then
        Game.world:loadMap(Game.world.map.id)
    elseif rand == 21 then
        for i=#Game.party, 2, -1 do
            Game:removePartyMember(Game.party[i])
        end
    elseif rand == 22 then
        Game.stage:removeFX("lostcolor")
        self.decreasesColorShader:send("lostcolor", {Utils.random(), Utils.random(), Utils.random()})
        Game.stage:addFX(ShaderFX(self.decreasesColorShader), "lostcolor")
    elseif rand == 23 then
        Game.stage:shake(Utils.random(10, 100), Utils.random(10, 100), Utils.random(), Utils.random(1/30, 1))
    elseif rand == 24 then
        table.shuffle(Assets.sounds, love.math.random(2, 10))
    elseif rand == 25 then
        local objects = Game.world.stage:getObjects(Character)
        for i,v in ipairs(Game.world.stage:getObjects(Event)) do
            table.insert(objects, v)
        end

        for i,v in ipairs(objects) do
            if v ~= Game.world.player then
                v:explode()
            end
        end
    elseif rand == 26 then
        for k,texture in pairs(Assets.data.texture) do
            Assets.data.texture[k] = self.mario
        end
        for k,texture in pairs(Assets.data.frames) do
            Assets.data.frames[k] = {self.mario}
        end
    elseif rand == 27 then
        local chara = Game.world:getCharacter(Game.party[love.math.random(1, #Game.party)].id)
        chara.sprite.flip_x = not chara.sprite.flip_x
        chara.sprite.flip_y = not chara.sprite.flip_y
    elseif rand == 28 then
        Game.world.camera.rotation = math.rad(Utils.random(380))
    elseif rand == 29 then
        if not Game.battle then
            Game:encounter(randomNotArray(Registry.encounters, false))
        else
            randomNotArray(Registry.encounters)()
        end
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
        local sprites = Game.world.stage:getObjects(Sprite)
        local sprite = sprites[love.math.random(1, #sprites)]
        sprite.scale_x = Utils.random(-5, 5)
        sprite.scale_y = Utils.random(-5, 5)
    elseif rand == 32 then
        for i=1,Game.world.map.width*40+Game.world.map.height*40 do
            Game.world.map:setTile(love.math.random(Game.world.map.width*40), love.math.random(Game.world.map.height*40), love.math.random(0, 924))
        end
    elseif rand == 33 then
        Game.world.player:setActor(randomNotArray(Registry.actors, false))
    end
end

return Plugin