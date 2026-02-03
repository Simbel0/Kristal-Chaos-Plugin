local RotateCameraEffect, super = Class(ChaosEffect, "rotateCamera_effect")

function RotateCameraEffect:onEffectStart(in_battle)
	(in_battle and Game.battle or Game.world).camera.rotation = math.rad(Utils.random(380))
end

return RotateCameraEffect