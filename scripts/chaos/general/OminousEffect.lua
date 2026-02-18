local OminousEffect, super = Class(ChaosEffect, "weirdroute_effect")

function OminousEffect:init()
	super.init(self)
	if not Chaos:getAsset("ominous") then
		Chaos:registerAsset("ominous", love.audio.newSource("assets/sounds/ominous.wav", "static"))
		Chaos:registerAsset("ominous_c", love.audio.newSource("assets/sounds/ominous_cancel.wav", "static"))
	end
end

function OminousEffect:onEffectStart(in_battle)
	Chaos:getAsset(love.math.random() < 0.5 and "ominous" or "ominous_c"):play()
end

return OminousEffect