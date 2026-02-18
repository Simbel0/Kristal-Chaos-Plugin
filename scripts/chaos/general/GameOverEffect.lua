local GameOverEffect, super = Class(ChaosEffect, "gameover_effect")

function GameOverEffect:onEffectStart(in_battle)
	local soul_x, soul_y
	if in_battle then
		if Game.battle.soul then
			soul_x, soul_y = Game.battle.soul:getPosition()
		else
			soul_x, soul_y = Game.battle.party[1]:getPosition()
		end
	elseif Game.world and Game.world.player then
		soul_x, soul_y = Game.world.player:getPosition()
	end
	Game:gameOver(soul_x, soul_y)
end

return GameOverEffect