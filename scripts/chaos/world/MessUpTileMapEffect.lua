local MessUpTilesMapEffect, super = Class(ChaosEffect, "messmaptiles_effect")

function MessUpTilesMapEffect:onEffectStart(in_battle)
	local map = Game.world.map
	if #map.tile_layers > 0 then
		for i=1,map.width*40+map.height*40 do
			map:setTile(love.math.random(map.width*40), love.math.random(map.height*40), love.math.random(0, 924), TableUtils.pick(map.tile_layers).name)
		end
	end
end

function MessUpTilesMapEffect:canRunEffect()
	return Game.world and Game.world.map
end

return MessUpTilesMapEffect