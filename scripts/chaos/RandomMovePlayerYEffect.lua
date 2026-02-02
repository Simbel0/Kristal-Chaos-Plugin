local RandomMovePlayerYEffect, super = Class(ChaosEffect, "randPlayerY_effect")

function RandomMovePlayerYEffect:onEffectStart(in_battle)
	if in_battle then
		if Game.battle.soul then
			Game.battle.soul.y = Game.battle.soul.y + MathUtils.random(-50, 50)
		else
			Game.battle.party[1].y = Game.battle.party[1].y + MathUtils.random(-50, 50)
		end
	else
		Game.world.player.y = Game.world.player.y + MathUtils.random(-50, 50)
	end
end

return RandomMovePlayerYEffect