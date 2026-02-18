local StarwalkerEffect, super = Class(ChaosEffect, "starwalker_effect")

function StarwalkerEffect:onEffectStart(in_battle)
	local w = Game.world.map.width*Game.world.map.tile_width
	local h = Game.world.map.height*Game.world.map.tile_height
	Game.world:spawnNPC("starwalker", Utils.random(50, w-50), Utils.random(50, h-50), {
		text = {
			"* This [color:yellow]plugin[color:reset] is [color:yellow]pissing[color:reset] me off...",
			"* I'm the original   [color:yellow]Starwalker[color:reset]"
		}
	})
end

function StarwalkerEffect:canRunEffect()
	return Game.world and Game.world.stage
end

return StarwalkerEffect