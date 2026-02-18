local RandomScaleEffect, super = Class(ChaosEffect, "scale_effect")

function RandomScaleEffect:init()
	super.init(self)
	self.sprites = Chaos.Utils:getAllInstancesOfClass(Sprite)
end

function RandomScaleEffect:onEffectStart(in_battle)
    local sprite = self.sprites[love.math.random(1, #self.sprites)]
    sprite.scale_x = Utils.random(-5, 5)
    sprite.scale_y = Utils.random(-5, 5)
end

function RandomScaleEffect:canRunEffect()
	return #self.sprites > 0
end

return RandomScaleEffect