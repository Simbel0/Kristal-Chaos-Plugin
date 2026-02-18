local MessUpScreenHeightEffect, super = Class(ChaosEffect, "screenHeight_effect")

function MessUpScreenHeightEffect:onEffectStart(in_battle)
	SCREEN_HEIGHT = Utils.random(10, 640)
end

return MessUpScreenHeightEffect