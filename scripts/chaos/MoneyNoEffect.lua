local MoneyNoEffect, super = Class(ChaosEffect, "moneyno_effect")

function MoneyNoEffect:onEffectStart(in_battle)
	if love.math.random() < 0.5 then
		Game.money = 0
	else
		Game.money = -Game.money
	end
end

return MoneyNoEffect