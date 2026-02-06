local ReloadMapEffect, super = Class(ChaosEffect, "reloadMap_effect")

function ReloadMapEffect:onEffectStart(in_battle)
	Game.world:loadMap(Game.world.map.id)
end

function ReloadMapEffect:canRunEffect()
    return Game.world and Game.world.map and not Game.battle
end

return ReloadMapEffect