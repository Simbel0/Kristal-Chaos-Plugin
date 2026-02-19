local MarioEffect, super = Class(ChaosEffect, "mario_effect")

function MarioEffect:init()
	super.init(self)
	if not Chaos:getAsset("mario") then
		Chaos:registerAsset("mario", love.graphics.newImage(Chaos.PATH.."/assets/sprites/mario.png"))
	end
end

function MarioEffect:onEffectStart(in_battle)
	local mario = Chaos:getAsset("mario")
	for k,texture in pairs(Assets.data.texture) do
        Assets.data.texture[k] = mario
    end
    for k,texture in pairs(Assets.data.frames) do
        Assets.data.frames[k] = {mario}
    end
    for k,id in pairs(Assets.texture_ids) do
        Assets.texture_ids[mario] = id
    end
end

return MarioEffect