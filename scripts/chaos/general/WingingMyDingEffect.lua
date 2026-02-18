local WingingMyDingEffect, super = Class(ChaosEffect, "gaster_effect")

function WingingMyDingEffect:onEffectStart(in_battle)
--[[local imwingdingtheroyalfont = Assets.getFont("wingding")
    for font,data in pairs(Assets.data.fonts) do
        print(font,data, type(data))
        if type(data) == "userdata" then
            Assets.data.fonts[font] = imwingdingtheroyalfont
        elseif type(data) == "table" then
            for size,data2 in pairs(data) do
                if type(v) == "userdata" then
                    Assets.data.fonts[font][size] = imwingdingtheroyalfont
                end
            end
        end
    end

    local imwingdingtheroyalfontdata = Assets.data.font_data["wingding"]
    for font,data in pairs(Assets.data.font_data) do
        Assets.data.font_data[font] = imwingdingtheroyalfontdata
    end]]
    Utils.hook(Assets, "getFont", function(orig, path, size)
        return orig("wingding", size)
    end)
end

return WingingMyDingEffect