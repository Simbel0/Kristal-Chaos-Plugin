local TooMuchPlayersEffect, super = Class(ChaosEffect, "manyPlayers_effect")

function TooMuchPlayersEffect:onEffectStart(in_battle)
	for i=1,love.math.random(1, 100) do
		local newPlayer = TableUtils.copy(Game.world.player, true)
		newPlayer:move(Utils.random(-300, 300), Utils.random(-300, 300))
		Game.world:addChild(newPlayer)
	end
end

return TooMuchPlayersEffect