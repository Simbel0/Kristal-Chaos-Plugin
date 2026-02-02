local MessUpScreenWidthEffect, super = Class(ChaosEffect, "screenWidth_effect")

function MessUpScreenWidthEffect:onEffectStart(in_battle)
	SCREEN_WIDTH = Utils.random(10, 640)
end

return MessUpScreenWidthEffect