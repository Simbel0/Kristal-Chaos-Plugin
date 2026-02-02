local InvertControlsEffect, super = Class(ChaosEffect, "invert_effect")

function InvertControlsEffect:init()
	self.duration = Utils.random(5, 60)
end

function InvertControlsEffect:onEffectStart(in_battle)
	Utils.hook(Player, "move", function(orig, self, x, y, speed, keep_facing)
        orig(self, y, x, speed, keep_facing)
    end)
end

function InvertControlsEffect:onEffectEnd()
	Utils.unhook(Player, "move")
end

function InvertControlsEffect:canRunEffect()
	-- I'll handle battles another day
	return Game.battle == nil
end

return InvertControlsEffect