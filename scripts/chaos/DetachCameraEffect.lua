local DetachCameraEffect, super = Class(ChaosEffect, "reloadMap_effect")

function DetachCameraEffect:init()
	super.init(self)
	self.duration = Utils.random(1, 10)
end

function DetachCameraEffect:onEffectStart(in_battle)
	Game.world.camera:setAttached(false)
end

function DetachCameraEffect:onEffectEnd()
	Game.world.camera:setAttached(true)
end

function DetachCameraEffect:canRunEffect()
    return Game.world and Game.world.camera
end

return DetachCameraEffect