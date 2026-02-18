local ReloadMapEffect, super = Class(ChaosEffect, "reloadMap_effect")

function ReloadMapEffect:onEffectStart(in_battle)
	if Game.world:hasCutscene() then
		Game.lock_movement = false
	end
	Game.world:loadMap(Game.world.map.id)
end

function ReloadMapEffect:canRunEffect()
    return Game.world and Game.world.map and not Game.battle
end

return ReloadMapEffect