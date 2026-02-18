-- testmod reference
local MyFellowAmericansEffect, super = Class(ChaosEffect, "letmebeclear_effect")

function MyFellowAmericansEffect:onEffectStart(in_battle)
	local enemy = TableUtils.pick(Game.battle.enemies)
	Assets.playSound("deathnoise", 1, 0.75)
    local alphafx = enemy:addFX(AlphaFX(1))
    Game.battle.timer:tween(1, alphafx, {alpha = 0}, nil, function()
    	Game.battle:removeEnemy(enemy, false)
    	if #Game.battle.enemies-1 == 0 then
    		Game.battle:setState("VICTORY")
    	end
    end)
end

function MyFellowAmericansEffect:canRunEffect()
	return Game.battle and #Game.battle.enemies > 0
end

return MyFellowAmericansEffect