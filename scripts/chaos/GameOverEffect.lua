local GameOverEffect, super = Class(ChaosEffect, "gameover_effect")

function GameOverEffect:onEffectStart(in_battle)
	Game:gameOver()
end

return GameOverEffect