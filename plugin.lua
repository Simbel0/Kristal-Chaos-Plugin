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
    local objects = Game.stage:getObjects(class)
    local stage = Game.battle or Game.world or Game.stage

    local correct_objects = {}
    for i,obj in ipairs(objects) do
        if self:isRecursiveParent(obj, stage) then
            table.insert(correct_objects, obj)
        end
    end

    return correct_objects
end

function Plugin.Utils:getAllInstancesOfClass(class, objs, recur_objs)
    local objects = objs or Game.stage:getObjects()
    local correct_objects = recur_objs or {}

    for i,obj in ipairs(objects) do
        if obj:includes(class) and not TableUtils.contains(correct_objects, obj) then
            table.insert(correct_objects, obj)
        end
        if obj.children and #obj.children > 0 then
            self:getAllInstancesOfClass(class, obj.children, correct_objects)
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
    self.registry = {}

    self.timer = Utils.random(60, 600)

    self.debugStopChaos = false

    -- Should be set to nil on release
    self.debug_chaos_pattern = nil--"^event.*Player"

    self.FRAMERATE = FRAMERATE

    self.chaos_effects = {}
    self.active_chaos = {}

    -- Possibly dangerous af but also needed as unload isn't called when an error occurs apparently??
    -- Some effect could leave huge modifications behind after a crash so unloading the plugin is just critical
    HookSystem.hook(Kristal, "errorHandler", function(orig, ...)
        local ok, err = pcall(self.unload, self)
        if ok then
            self.print("A crash occurred!! Chaos Plugin was able to unload itself")
        else
            self.print("A crash occurred!! Chaos Plugin met an error trying to unload itself: "..err)
        end
        return orig(...)
    end)

    HookSystem.hook(HookSystem, "unhook", function(_, target, name)
        for i, hook in ipairs(HookSystem.__MOD_HOOKS) do
            if hook.target == target and hook.name == name then
                hook.target[hook.name] = hook.orig
                table.remove(HookSystem.__MOD_HOOKS, i)
                return true
            end
        end
    end)

    --- @class TableUtils
    --- Returns a list of every key in a table.
    ---
    ---@generic T
    ---@param t table<T, any> # The table to get the keys from.
    ---@return T[] result     # An array of each key in the table.
    ---
    HookSystem.hook(TableUtils, "getValues", function(_, t)
        local result = {}
        for _, value in pairs(t) do
            table.insert(result, value)
        end
        return result
    end)

    for path, name, effect in Registry.iterScripts("chaos", true) do
        if effect == nil then
            local _, path_end = path:find("chaos/")
            local error_path = (path_end and '"chaos/' .. path:sub(path_end+1) .. '.lua"' or '"'..path..'.lua"')
            error(error_path.." does not return value")
        end

        local id = effect.id or name
        if self.debug_chaos_pattern then
            if not string.match(id, self.debug_chaos_pattern) then
                self.print("Effect with id \""..id.."\" was not loaded due to debug pattern!")
                goto continue -- when the fuck will Lua get a continue keyword
            end
        end
        self.chaos_effects[id] = effect
        ::continue::
    end

    self.print(#self:getEffectIDs().." effects loaded!")
end

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

function Plugin:postUpdate()
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

function Plugin:getActiveEffects()
    return self.active_chaos
end

function Plugin:getActiveEffectsOfID(id)
    return TableUtils.filter(self:getActiveEffects(), function(v) return v.id == id end)
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

return Plugin
