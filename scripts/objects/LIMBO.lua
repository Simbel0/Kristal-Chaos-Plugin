local LIMBO, super = Class(Object)

function LIMBO:init()
	super.init(self, 0, 0, 640, 480)

	self.music = Chaos:getAsset("limbo")
	self.music:setLooping(false)

	self.keys_tex = Assets.getTexture("player/heart_dodge")
	self.keys_wrong_tex = Assets.getTexture("player/heart_break")
	self.keys_data = {}
	self.keys_radius = 150
	self.key_speed = 0.5
	self.key_rotate_timer = 0
	self.key_rotate_speed = 0.2

	self.use_wrong = false

	local x, y = (640/2)-80, 100
	for i=1,8 do
		table.insert(self.keys_data, {
			pos = {640/2, -20},
			destination = {x, y},
			--use_approach = false,
			move_timer = 0,
			use_color = true,
			color_alpha = 1
		})
		x = x + 80
		if i%2 == 0 then
			x = (640/2)-80
			y = y + 80
		end
	end
	self:randomizeColors()

	self.correct_key = love.math.random(1, 8)
	self.selected_key = 0

	self.music:play()

	--- self.state
	-- 0: show all colored souls
	-- 1: decolor all souls except the correct one
	-- 2: wait to shuffle
	-- 3: LIMBO
	-- 4: wait for player's choice
	-- 10: debug. Press CONFIRM to shuffle
	self.state = 0
end

function LIMBO:randomizeColors()
	local blacklist = {"white", "gray", "ltgray", "dkgray", "black", "teal", "silver"}
	local keys_color = TableUtils.filter(TableUtils.getKeys(COLORS), function(v) return not TableUtils.contains(blacklist, v) end)

	for i,data in ipairs(self.keys_data) do
		data.color = COLORS[table.remove(keys_color, love.math.random(1, #keys_color))]
	end
end

function LIMBO:isKeyAtDestination(key_data)
	if type(keys_data) == "number" then
		keys_data = self.keys_data[key_data]
	end
	return Utils.equal(key_data.pos, key_data.destination)
end

function LIMBO:areAllKeysAtDestination()
	for i,data in ipairs(self.keys_data) do
		if not self:isKeyAtDestination(data) then
			return false
		end
	end
	return true
end

local function createMatrix(tbl, w)
	local m = {}
	local temp = {}

	local w_count = 0
	for i,v in ipairs(tbl) do
		table.insert(temp, v)
		w_count = w_count + 1
		if (w_count >= w) then
			w_count = 0
			table.insert(m, TableUtils.copy(temp, true))
			temp = {}
		end
	end

	return m
end

function LIMBO:shuffleKeys()
	local all_pos = {}
	for i,data in ipairs(self.keys_data) do
		table.insert(all_pos, data.pos)
	end

	local matrix = createMatrix(all_pos, 2)

	local shuffle_mode = love.math.random(1,4)

	if shuffle_mode == 1 then
		matrix = TableUtils.flip(matrix)
	elseif shuffle_mode == 2 then
		matrix = TableUtils.rotate(matrix, Utils.random()<0.5)
	elseif shuffle_mode == 3 then
		matrix = TableUtils.shuffle(matrix)
	elseif shuffle_mode == 4 then
		matrix = TableUtils.reverse(matrix)
	end

	local new_dest = TableUtils.flatten(matrix)
	for i,data in ipairs(self.keys_data) do
		data.move_timer = 0
		data.destination = table.remove(new_dest, 1)
	end
end

local function rectCollision(x, y, rect_data)
	return x >= rect_data.x
	   and x <= rect_data.x + rect_data.width
	   and y >= rect_data.y
	   and y <= rect_data.y + rect_data.height
end

function LIMBO:update()
	super.update(self)
	if self.success ~= nil then return end
	if self.music:tell() >= 5 and self.state == 0 then
		self.state = 1
		for i,data in ipairs(self.keys_data) do
			if i ~= self.correct_key then
				data.use_color = false
			end
		end
	elseif self.music:tell() >= 6 and self.state == 1 then
		self.state = 2
		self.keys_data[self.correct_key].use_color = false
	elseif self.music:tell() >= 9.5 and self.state == 2 then
		self.state = 3
		self.key_speed = 7.5
	elseif self.music:tell() >= 28.7 and self.state == 3 then
		self.state = 4
		self.key_speed = 2
		self:randomizeColors()
		for i,data in ipairs(self.keys_data) do
			data.use_color = true
			data.move_timer = 0
		end
	end

	for i,data in ipairs(self.keys_data) do
		if not self:isKeyAtDestination(data) then
			data.move_timer = Utils.clamp(data.move_timer + (self.key_speed/100)*DTMULT, 0, 1)
			data.pos = TableUtils.lerp(data.pos, data.destination, data.move_timer)
			--data.pos[1] = MathUtils.approach(data.pos[1], data.destination[1], self.key_speed*DTMULT)
			--data.pos[2] = MathUtils.approach(data.pos[2], data.destination[2], self.key_speed*DTMULT)
		end

		if not data.use_color and data.color_alpha > 0 then
			data.color_alpha = data.color_alpha - 0.1*DTMULT
		elseif data.use_color and data.color_alpha < 1 then
			data.color_alpha = data.color_alpha + 0.1*DTMULT
		end
	end

	if self.state == 4 or self.state == 5 then
		local mX, mY = Input.getMousePosition()

		for i,data in ipairs(self.keys_data) do
			local circle = (2 * math.pi)
			self.key_rotate_timer = self.key_rotate_timer+(self.key_rotate_speed/100)*DTMULT
			local angle = (self.key_rotate_timer + (i-1) * (circle / #self.keys_data))%circle
			local x = (640/2) + math.cos(angle) * self.keys_radius
			local y = (480/2) - math.sin(angle) * self.keys_radius

			data.destination = {x, y}

			if self.state == 4 and Input.mousePressed(1) and rectCollision(mX, mY, {x=x, y=y, width=self.keys_tex:getWidth(), height=self.keys_tex:getHeight()}) then
				self.selected_key = i
				self.state = 5
				for i,data in ipairs(self.keys_data) do
					data.color_alpha = 0
				end
				break
			elseif self.state == 5 then
				self.key_rotate_speed = MathUtils.clamp(self.key_rotate_speed-0.0005*DTMULT, 0, 999)
				if self.key_rotate_speed <= 0 then
					self.state = 6
				end
			end
		end
	elseif self.state == 6 then
		local next = true
		for i,data in ipairs(self.keys_data) do
			if self.state == 6 and i ~= self.selected_key then
				data.color[4] = MathUtils.clamp(data.color[4] - 0.1*DTMULT, 0, 1)
				if data.color[4] > 0 and next then
					next = false
				end
			end
		end

		if next then
			self.timer = 60
			self.state = 7
		end
	elseif self.state == 7 or self.state == 9 then
		self.timer = (self.timer or 120) - DTMULT
		if self.timer <= 0 then
			self.timer = nil
			self.state = self.state + 1
		end
	elseif self.state == 8 then
		if self.selected_key == self.correct_key then
			Assets.playSound("won")
			self.keys_data[self.selected_key].color_alpha = 0
		else
			self.use_wrong = true
			self.timer = 30
			Assets.playSound("break1")
		end
		self.state = 9
	elseif self.state == 10 then
		self.success = (self.selected_key == self.correct_key)
	end

	if self.state == 3 and self:areAllKeysAtDestination() then
		self:shuffleKeys()
	elseif self.state == 10 and Input.down("confirm") and self:areAllKeysAtDestination() then
		self:shuffleKeys()
	end
end

function LIMBO:hasFailed()
	return self.success == false
end

function LIMBO:hasSucceeded()
	return self.success == true
end

function LIMBO:draw()
	for i,data in ipairs(self.keys_data) do
		local x, y = unpack(data.pos)
		love.graphics.setColor(ColorUtils.mergeColor(COLORS.white, data.color, data.color_alpha))
		Draw.draw(self.use_wrong and self.keys_wrong_tex or self.keys_tex, x, y)
	end

	if DEBUG_RENDER then
		love.graphics.setFont(Assets.getFont("main_mono"))
		Draw.setColor(self:areAllKeysAtDestination() and COLORS.white or COLORS.red)
		Draw.printShadow("Matrix:", 5, 10)
		self:drawDebugMatrix(10, 50, "pos")
		self:drawDebugMatrix(10, 50+36+40*4, "destination")
	end

	super.draw(self)
end

function LIMBO:drawDebugMatrix(x, y, value)
	for i=1,#self.keys_data,2 do
		local data = self.keys_data[i]
		local data2 = self.keys_data[i+1]

		local Kx, Ky = unpack(data[value])
		local K2x, K2y = unpack(data2 and data2[value] or {"X", "X"})

		Draw.setColor(self:isKeyAtDestination(data) and COLORS.white or COLORS.red)
		local line = "("..Kx..", "..Ky..")"
		Draw.printShadow(line, x, y)

		if data2 then
			Draw.setColor(self:isKeyAtDestination(data2) and COLORS.white or COLORS.red)
			Draw.printShadow("("..K2x..", "..K2y..")", x+Assets.getFont("main_mono"):getWidth(line)+16, y)
		end
		y = y + 40
	end
	Draw.setColor(COLORS.white)
end

return LIMBO