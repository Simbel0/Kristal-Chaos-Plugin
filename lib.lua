local Plugin = love.filesystem.load(Mod.info.libs["chaos_lib"].path.."/plugin.lua")()
Plugin.IS_LIBRARY = true
Plugin.PATH = Mod.info.libs["chaos_lib"].path
return Plugin