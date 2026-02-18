local MessTimescaleObjectsEffect, super = Class(ChaosEffect, "timescale_effect")

function MessTimescaleObjectsEffect:onEffectStart(in_battle)
	local objects = Chaos.Utils:getAllInstancesOfClass(Object)
	for i,obj in ipairs(objects) do
		obj.timescale = Utils.random(0.1, 2)
	end
end

return MessTimescaleObjectsEffect