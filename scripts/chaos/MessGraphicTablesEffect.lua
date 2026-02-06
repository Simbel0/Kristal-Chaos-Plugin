local MessGraphicTablesEffect, super = Class(ChaosEffect, "graphics_effect")

function MessGraphicTablesEffect:onEffectStart(in_battle)
	local objects = Chaos.Utils:getAllInstancesOfClass(Object)
	if #objects == 0 then
		self:stopEffect()
		return
	end

	local graphics = {}
	for i,obj in ipairs(objects) do
		table.insert(graphics, obj.graphics)
	end

	for i=1,love.math.random(5) do
		objects = TableUtils.shuffle(objects)
		graphics = TableUtils.shuffle(graphics)
	end

	for i,obj in ipairs(objects) do
		obj:setGraphics(graphics[i])
	end
end

function MessGraphicTablesEffect:canRunEffect()
	return Game.stage
end

return MessGraphicTablesEffect