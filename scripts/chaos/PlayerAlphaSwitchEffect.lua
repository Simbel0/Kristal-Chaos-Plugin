local PlayerAlphaSwitchEffect, super = Class(ChaosEffect, "playerAlphaSwitch_effect")

function PlayerAlphaSwitchEffect:onEffectStart(in_battle)
	if in_battle then
		if Game.battle.soul then
			Game.battle.soul.alpha = Game.battle.soul.alpha == 1 and 0 or 1
		else
			Game.battle.party[1].alpha = Game.battle.party[1].alpha == 1 and 0 or 1
		end
	end
	Game.world.player.alpha = Game.world.player.alpha == 1 and 0 or 1
end

function PlayerAlphaSwitchEffect:canRunEffect()
	return (Game.world and Game.world.player) or (Game.battle and (#Game.battle.party>0 or Game.battle.soul))
end

return PlayerAlphaSwitchEffect