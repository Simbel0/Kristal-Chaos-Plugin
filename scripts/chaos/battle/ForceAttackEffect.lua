local ForceAttackEffect, super = Class(ChaosEffect, "forceAttack_effect")

function ForceAttackEffect:init()
	super.init(self)
	self.duration = math.huge

	self.turns = love.math.random(1, 5)
	Chaos.print(self.turns)
end

function ForceAttackEffect:update()
	if Game.battle:getState() == "ACTIONSELECT" then
		self.turns = self.turns - 1
		for i,battler in ipairs(Game.battle.party) do
			Game.battle:pushForcedAction(battler, "AUTOATTACK", Game.battle:getActiveEnemies()[1], nil, {points = 150})
		end
	end
	if self.turns <= 0 then
		self:stopEffect()
	end
end

function ForceAttackEffect:canRunEffect()
	return Game.battle
end

return ForceAttackEffect