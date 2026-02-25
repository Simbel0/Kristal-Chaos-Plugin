local ChaosOptionsState, super = Class(StateClass)

local function populateTableFileTree(filetree, path, notfirst)
	for i,name in ipairs(love.filesystem.getDirectoryItems(path)) do
		local item = love.filesystem.getInfo(path.."/"..name)
		if item.type == "file" and StringUtils.endsWith(name, ".lua") then
			table.insert(filetree, name)
		elseif item.type == "directory" then
			filetree[name] = {open=false}
			populateTableFileTree(filetree[name], path.."/"..name)
		end
	end
end

local function flattenFileTree(filetree, final)
	local t = final or {}
	for k,v in pairs(filetree) do
        if type(k) == "string" and type(v) ~= "boolean" then
        	table.insert(t, {name=k,open=v.open})
        	if v.open then
        		flattenFileTree(v, t)
        	end
        end
	end
	for i,v in ipairs(filetree) do
		table.insert(t, v)
	end
	return t
end

local function iterFileTree(filetree)
	local files = flattenFileTree(filetree)

	local index = 0
	local max_index = #files

	local offset = 0
	return function()
		index = index + 1
		if index > max_index then
			return
		end

		local file = files[index]
		local is_folder = false
		local is_opened = nil
		if type(file) == "table" then
			is_folder = true
			is_opened = file.open
			offset = offset + (file.open and 32 or -32)
			file = file.name
			if offset < 0 then offset = 0 end
		end

		-- index: duh
		-- file: a file or a folder
		-- offset: increases when we're going in a folder
		return index, file, offset, is_folder, is_opened
	end
end

function ChaosOptionsState:init(menu)
	self.menu = menu
	
    self.font = Assets.getFont("main")

    self.selected_option = 1

    self.scroll_target_y = 0
    self.scroll_y = 0

    -- MAIN, CHAOSTOGGLE, NUMBERCHOOSE
    self.state = "MAIN"

    -- Options:
    -- Chaos Mult.
    -- Auto-Save
    -- Toggle effects

    self.options = {
    	{
    		name = "Chaos Mult.",
    		config = "mult",
    		default = 1,
    		limits = {min=0.1,max=50},
    		desc = "Decides how fast Chaos effects happens.\n1x is normal speed, 2x is double, etc.",
    		value = function(v)
    			return v.."x"
    		end,
    		new_value = function(v, key)
    			local mult = 1
				if v < 1 or (v == 1 and Input.is("left", key)) then
					mult = 0.1
				elseif v > 10 or (v == 10 and Input.is("right", key)) then
					mult = 5
				end

				if Input.is("left", key) then
					v = v - mult
				end
				if Input.is("right", key) then
					v = v + mult
				end

				return v
			end
    	},
    	{
    		name = "Auto-Save",
    		config = "autosave",
    		default = false,
    		desc = "Saves the game after going through a transition.\n!!SAVES OVER THE SAVE YOU CHOOSE!!",
    		value = function(v)
    			return v and "ON" or "OFF"
    		end
    	},
    	{
    		name = "Little Devil",
    		config = "jevil",
    		default = false,
    		desc = "A certain devil will laugh whenever a chaos effect activates.",
    		value = function(v)
    			return v and "ON" or "OFF"
    		end
    	},
    	{
    	--[[{
    		name = "Toggle Effects",
    		config = "off_effects",
    		default = {},
    		desc = "Toggle on or off the Chaos Effects.",
    		state = "CHAOSTOGGLE"
    	}]]
    }

    self.config = Kristal.Config["plugins/chaos"] or {}
    if #TableUtils.getKeys(self.config) == 0 then
    	for i,v in ipairs(self.options) do
    		self.config[v.config] = v.default
    	end
    end

    --[[self.chaos_effects = {}
    local path
    for plugin in Kristal.PluginLoader:iterPlugins() do
    	if plugin.id == "chaos_plugin" then
    		path = plugin.path
    		break
    	end
	end

	if not path then
		return
	end

	populateTableFileTree(self.chaos_effects, path.."/scripts/chaos")]]
end

function ChaosOptionsState:registerEvents()
    self:registerEvent("enter", self.onEnter)
    self:registerEvent("leave", self.onLeave)
    self:registerEvent("keypressed", self.onKeyPressed)
    self:registerEvent("update", self.update)
    self:registerEvent("draw", self.draw)
end

function ChaosOptionsState:onEnter(old_state)
    if old_state == "MODSELECT" then
        self.selected_option = 1

        self.scroll_target_y = 0
        self.scroll_y = 0
    end
end

function ChaosOptionsState:onLeave()
	Kristal.Config["plugins/chaos"] = self.config
	Kristal.saveConfig()
end

function ChaosOptionsState:onKeyPressed(key, is_repeat)
	if Input.isCancel(key) then
		Assets.stopAndPlaySound("ui_move")
		if self.old_selected_option then
			self.selected_option = self.old_selected_option
			self.old_selected_option = nil
		end
		if self.state == "MAIN" then
        	self.menu:setState("plugins")
        else
        	self.state = "MAIN"
        end
        return
    end

    if self.state == "MAIN" then
	    local options = self.options
	    local max_option = #options + 1

	    local old_option = self.selected_option
	    if Input.is("up", key) then self.selected_option = self.selected_option - 1 end
	    if Input.is("down", key) then self.selected_option = self.selected_option + 1 end
	    self.selected_option = MathUtils.clamp(self.selected_option, 1, max_option)

	    if old_option ~= self.selected_option then
	    	Assets.stopAndPlaySound("ui_move")
	    end
	elseif self.state == "NUMBERCHOOSE" then
		local option = self.options[self.selected_option]
		local config = self.config[option.config]
		local old_config = config

		if option.new_value then
			config = option.new_value(config, key)
		else
			if Input.is("left", key) then
				config = config - 1
			end
			if Input.is("right", key) then
				config = config + 1
			end
		end

		self.config[option.config] = MathUtils.clamp(config, option.limits.min, option.limits.max)

		if old_config ~= self.config[option.config] then
	    	Assets.stopAndPlaySound("ui_move")
	    end
	elseif self.state == "CHAOSTOGGLE" then
	    local max_option = #flattenFileTree(self.chaos_effects) + 1

	    local old_option = self.selected_option
	    if Input.is("up", key) then self.selected_option = self.selected_option - 1 end
	    if Input.is("down", key) then self.selected_option = self.selected_option + 1 end
	    self.selected_option = MathUtils.clamp(self.selected_option, 1, max_option)

	    if old_option ~= self.selected_option then
	    	Assets.stopAndPlaySound("ui_move")
	    end
	end

    if Input.isConfirm(key) then
    	Assets.stopAndPlaySound("ui_select")

    	if self.state == "MAIN" then
	    	if self.selected_option == max_option then
	    		Assets.stopAndPlaySound("ui_move")
	    		self.menu:setState("plugins")
	    		return
	    	else
	    		local option = self.options[self.selected_option]
	    		if type(option.default) == "boolean" then
	    			self.config[option.config] = not self.config[option.config]
	    		elseif type(option.default) == "number" then
	    			self.state = "NUMBERCHOOSE"
	    		elseif option.state then
	    			self.state = option.state
	    			self.old_selected_option = self.selected_option
	    			self.selected_option = 1
	    		end
	    	end
	    elseif self.state == "CHAOSTOGGLE" then
	    	local file = flattenFileTree(self.chaos_effects)[self.selected_option]

	    	if type(file) == "table" then
	    		self.chaos_effects[file.name].open = not self.chaos_effects[file.name].open
	    	else
	    		if not TableUtils.contains(self.config["off_effects"], file) then
	    			table.insert(self.config["off_effects"], file)
	    		else
	    			TableUtils.removeValue(self.config["off_effects"], file)
	    		end
	    	end
	    end
    end
end

function ChaosOptionsState:getHeartPos(max_option)
    local x, y = 152, 129

    if self.selected_option < max_option then
        x = 152
        y = 129 + (self.selected_option - 1) * 32 + self.scroll_target_y
    else
        -- "Back" button
        x = 320 - 32 - 16 + 1
        y = 480 - 16 + 1
    end

    return (self.state == "NUMBERCHOOSE" and x + (32 * 8) or x), y
end

function ChaosOptionsState:update()
    local max_option = #self.options + 1
    if self.state == "CHAOSTOGGLE" then
    	max_option = #flattenFileTree(self.chaos_effects)
    end

    if self.selected_option < max_option then
        local y_off = (self.selected_option - 1) * 32

        if y_off + self.scroll_target_y < 0 then
            self.scroll_target_y = self.scroll_target_y + (0 - (y_off + self.scroll_target_y))
        end

        if y_off + self.scroll_target_y > (9 * 32) then
            self.scroll_target_y = self.scroll_target_y + ((9 * 32) - (y_off + self.scroll_target_y))
        end
    end

    if (math.abs((self.scroll_target_y - self.scroll_y)) <= 2) then
        self.scroll_y = self.scroll_target_y
    end
    self.scroll_y = self.scroll_y + ((self.scroll_target_y - self.scroll_y) / 2) * DTMULT

    self.menu.heart_target_x, self.menu.heart_target_y = self:getHeartPos(max_option)
end

local function getWrappedHeight(font, text, limit)
	local _, lines = font:getWrap(text, limit)
	local base_height = font:getHeight(text)
	local total_height = 0
	for i=1,#lines do
		total_height = total_height + base_height
	end
	return total_height
end

function ChaosOptionsState:drawMenu()
	return TableUtils.contains({"MAIN", "NUMBERCHOOSE"}, self.state)
end

function ChaosOptionsState:draw()
	if self:drawMenu() then
		local menu_font = self.font

	    local options = self.options

	    local title = "CHAOS PLUGIN"
	    local title_width = menu_font:getWidth(title)

	    love.graphics.setFont(menu_font)
	    Draw.setColor(1, 1, 1)
	    Draw.printShadow(title, 0, 48, 2, "center", 640)

	    local menu_x = 185 - 14
	    local menu_y = 110

	    local width = 360
	    local height = 32 * 10
	    local total_height = 32 * #options

	    for i,option in ipairs(options) do
	    	local y = menu_y + 32 * (i - 1)

	        Draw.printShadow(option.name, menu_x, y)

	        local value_x = menu_x + (32 * 8)
	        local value = option.value and option.value(self.config[option.config]) or nil
	        if option.state then value = ">" end
	        if value then
	            Draw.printShadow(tostring(value), value_x, y)
	        end
	    end

	    if self.selected_option > 0 and self.selected_option <= #options and options[self.selected_option].desc then
	    	Draw.setColor(0.5, 0.5, 0.5)
	    	local text = options[self.selected_option].desc
	    	Draw.printShadow(text, 10, SCREEN_HEIGHT-getWrappedHeight(menu_font, text, SCREEN_WIDTH-10), nil, "center", SCREEN_WIDTH-10)
	    	Draw.setColor(1, 1, 1)
	    else
	    	Draw.printShadow("Back", 0, 454 - 8, 2, "center", 640)
	    end
	elseif self.state == "CHAOSTOGGLE" then
		local menu_x = 185 - 14
	    local menu_y = 110

	    local width = 360
    	local height = 32 * 10
    	local total_height = 32 * #flattenFileTree(self.chaos_effects)

	    Draw.pushScissor()
    	Draw.scissor(menu_x, menu_y, width + 10, height + 10)

    	menu_y = menu_y + self.scroll_y

	    local old_offset = 0
	    for i, file, offset, is_folder, is_opened in iterFileTree(self.chaos_effects) do
	    	-- To prevent folders from being also moved to the right...
	    	--local true_offset = offset
	    	--if old_offset ~= offset then
	    	--	true_offset = offset - 32
	    	--	old_offset = offset
	    	--end

	    	local y = menu_y + 32 * (i - 1)
	    	local suffix = ""
	    	if is_folder then
	    		suffix = is_opened and " v" or " >"
	    	end

	    	if is_opened then
	    		Draw.setColor(COLORS.aqua)
	    	elseif TableUtils.contains(self.config["off_effects"], file) then
	    		Draw.setColor(COLORS.red)
	    	else
	    		Draw.setColor(COLORS.white)
	    	end
	    	Draw.printShadow(file..suffix, menu_x+offset, y)
	    end

	    -- Draw the scrollbar background if the menu scrolls
	    if total_height > height then
	        Draw.setColor({ 0, 0, 0, 0.5 })
	        love.graphics.rectangle("fill", menu_x + width, 0, 4, menu_y + height - self.scroll_y)

	        local scrollbar_height = (height / total_height) * height
	        local scrollbar_y = (-self.scroll_y / (total_height - height)) * (height - scrollbar_height)

	        Draw.popScissor()
	        Draw.setColor(1, 1, 1, 1)
	        love.graphics.rectangle("fill", menu_x + width, menu_y + scrollbar_y - self.scroll_y, 4, scrollbar_height)
	    else
	        Draw.popScissor()
	    end

		Draw.printShadow("Back", 0, 454 - 8, 2, "center", 640)
	end
end

return ChaosOptionsState