local MoveRandomCollisionsEffect, super = Class(ChaosEffect, "moveRandColliders_effect")

function MoveRandomCollisionsEffect:onEffectStart(in_battle)
	for i,collider in ipairs(Game.world.map.collision) do
        local off_x = Utils.random(-100, 100)
        local off_y = Utils.random(-100, 100)

        collider.x = collider.x+off_x
        collider.y = collider.y+off_y
    end
end

function MoveRandomCollisionsEffect:canRunEffect()
	return Game.world and Game.world.map
end

return MoveRandomCollisionsEffect