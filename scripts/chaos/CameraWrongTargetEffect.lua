local CameraWrongTargetEffect, super = Class(ChaosEffect, "cameraretarget_effect")

function CameraWrongTargetEffect:init()
	super.init(self)
	self.duration = Utils.random(1, 10)
end

function CameraWrongTargetEffect:onEffectStart(in_battle)
	local objects = TableUtils.mergeMany(Game.world.stage:getObjects(Event), Game.world.stage:getObjects(Character))
    Game.world.camera.target = objects[love.math.random(1, #objects)]
end

function CameraWrongTargetEffect:onEffectEnd()
	Game.world.camera.target = Game.world.player
end

function CameraWrongTargetEffect:canRunEffect()
	return Game.world and Game.world.stage
end

return CameraWrongTargetEffect