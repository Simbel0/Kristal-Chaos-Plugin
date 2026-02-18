local MessPhysicTablesEffect, super = Class(ChaosEffect, "physics_effect")

function MessPhysicTablesEffect:onEffectStart(in_battle)
	local objects = Chaos.Utils:getAllInstancesOfClass(Object)
	if #objects == 0 then
		self:stopEffect()
		return
	end

	local physics = {}
	for i,obj in ipairs(objects) do
		table.insert(physics, obj.physics)
	end

	for i=1,love.math.random(1, 5) do
		objects = TableUtils.shuffle(objects)
		physics = TableUtils.shuffle(physics)
	end

	for i,obj in ipairs(objects) do
		obj:setPhysics(physics[i] or {})
	end
end

function MessPhysicTablesEffect:canRunEffect()
	return Game.stage
end

return MessPhysicTablesEffect