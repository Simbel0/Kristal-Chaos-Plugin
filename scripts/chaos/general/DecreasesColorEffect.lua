local DecreasesColorEffect, super = Class(ChaosEffect, "lesscolor_effect")

function DecreasesColorEffect:init()
    super.init(self)
    if not Chaos:getAsset("color_shader") then
        local shader = love.graphics.newShader([[
            extern vec3 lostcolor;

            vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords )
            {
                vec4 outputcolor = Texel(tex, texture_coords) * color;
                vec3 newcolor = outputcolor.rbg - lostcolor.rgb;
                return vec4(newcolor.r, newcolor.g, newcolor.b, color.a);
            }
        ]])
        Chaos:registerAsset("color_shader", shader)
    end
end

function DecreasesColorEffect:onEffectStart(in_battle)
    local shader = Chaos:getAsset("color_shader")
    Game.stage:removeFX("lostcolor")
    shader:send("lostcolor", {Utils.random(), Utils.random(), Utils.random()})
    Game.stage:addFX(ShaderFX(shader), "lostcolor")
end

function DecreasesColorEffect:canRunEffect()
    return Game.stage ~= nil
end

return DecreasesColorEffect