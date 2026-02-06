local DiscordEffect, super = Class(ChaosEffect, "discord_effect")

function DiscordEffect:init()
	super.init(self)
	if not Chaos:getAsset("discord_ping") then
		Chaos:registerAsset("discord_ping", love.audio.newSource("mods/chaos/assets/sounds/ping.wav", "static"))
	end
end

function DiscordEffect:onEffectStart(in_battle)
	Chaos:getAsset("discord_ping"):play()
end

return DiscordEffect