local DebugSystemEffect, super = Class(ChaosEffect, "debugSystem_effect")

function DebugSystemEffect:onEffectStart(in_battle)
	Kristal.DebugSystem:openMenu()
end

return DebugSystemEffect