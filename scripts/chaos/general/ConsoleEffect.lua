local ConsoleEffect, super = Class(ChaosEffect, "console_effect")

function ConsoleEffect:onEffectStart(in_battle)
	Kristal.Console:open()
end

return ConsoleEffect