local MoveCollisionsEffect, super = Class(ChaosEffect, "moveColliders_effect")

function MoveCollisionsEffect:onEffectStart(in_battle)
	local off_x = Utils.random(-100, 100)
    local off_y = Utils.random(-100, 100)
    for i,collider in ipairs(Game.world.map.collision) do
        collider.x = collider.x+off_x
        collider.y = collider.y+off_y
    end
end

function MoveCollisionsEffect:canRunEffect()
	return Game.world and Game.world.map
end

return MoveCollisionsEffect