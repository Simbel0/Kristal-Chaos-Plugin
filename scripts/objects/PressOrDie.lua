local PressOrDie, super = Class(Object)

function PressOrDie:init(hard)
	super.init(self, 0, 0, 640, 480)

	if hard == nil then
		hard = Utils.random()<0.5
	end

	self.inputs = {}
	if not Input.usingGamepad() then
		TableUtils.merge(self.inputs, {"left", "right", "up", "down"})
		for i=97,122 do
		    table.insert(self.inputs, string.char(i))
		end
		--for i=1,12 do
		--    table.insert(self.inputs, "f"..i)
		--end
	else
		TableUtils.merge(self.inputs, TableUtils.flatten(TableUtils.getValues(Input.gamepad_bindings), true))
	end

	self.font = Assets.getFont("main_mono")
	if hard then
		self.spacing = 25
		self.max_width = 0
		self.input_order = {}
		for i=1,love.math.random(3, 6) do
			local key = TableUtils.pick(self.inputs)
			table.insert(self.input_order, key)

			if Input.usingGamepad() then
				local input_tex = Input.getTexture(key)
				if input_tex == Assets.getTexture("kristal/buttons/unknown") then
					input_tex = "["..key:upper().."]"
				end
				self.max_width = self.max_width + (type(input_tex) == "string" and self.font:getWidth(input_tex) or input_tex:getWidth()) + self.spacing
			else
				local input_name = Input.getText(key)
				if input_name:find("UNBOUND") then
					input_name = "["..key:upper().."]"
				end
				self.max_width = self.max_width + self.font:getWidth(input_name) + self.spacing
			end
		end
		self.index = 1
	else
		self.selected_input = TableUtils.pick(self.inputs)
	end

	self.success = nil

	self.dead_time = 15
end

function PressOrDie:hasFailed()
	return self.success == false
end

function PressOrDie:hasSucceeded()
	return self.success == true
end

local function hasPressedInput(input)
	for input_key,pressed in pairs(Input.key_pressed) do
		if pressed and input_key == input then
			return true
		end
	end
	return false
end

function PressOrDie:update()
	super.update(self)
	if self.success ~= nil then return end
	if self.dead_time > 0 then
		self.dead_time = self.dead_time - DTMULT
		return
	end

	if #TableUtils.getKeys(Input.key_pressed) == 0 then
		return
	end

	if self.selected_input then
		if hasPressedInput(self.selected_input) then
			self.success = true
		else
			self.success = false
		end
	elseif self.input_order then
		if hasPressedInput(self.input_order[self.index]) then
			self.index = self.index + 1
			Input.clear()
			if self.index > #self.input_order then
				self.success = true
			end
		else
			self.success = false
		end
	end
end

function PressOrDie:draw()
	love.graphics.setFont(self.font)

	if self.selected_input then
		Draw.printAlign("Press the input!", (640/2), 100, "center")
		if Input.usingGamepad() then
			local input_tex = Input.getTexture(self.selected_input)
			Draw.draw(input_tex, (640/2)/input_tex:getWidth()/2, 215)
		else
			local input_name = Input.getText(self.selected_input)
			if input_name:find("UNBOUND") then
				input_name = "["..self.selected_input:upper().."]"
			end
			Draw.printAlign(input_name, (640/2), 145, "center")
		end
	elseif self.input_order then
		Draw.printAlign("Press the inputs in order!", (640/2), 100, "center")
		local x = (640/2)-self.max_width/2
		for i,key in ipairs(self.input_order) do
			local input_name = Input.getText(key)
			if input_name:find("UNBOUND") then
				input_name = "["..key:upper().."]"
			end

			if self.index > i then
				Draw.setColor(COLORS.lime)
			elseif self.index == i then
				Draw.setColor(COLORS.yellow)
			else
				Draw.setColor(COLORS.white)
			end

			Draw.printAlign(input_name, x, 145, "left")
			x = x + self.font:getWidth(input_name) + self.spacing
		end
	end
	super.draw(self)
end

return PressOrDie