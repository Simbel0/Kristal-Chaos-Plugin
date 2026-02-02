local ChaosEffect, super = Class()

function ChaosEffect:init()
	self.duration = -1
end

function ChaosEffect:onEffectStart(in_battle) end

--- IMPORTANT: If you mess with certain Kristal globals in any way, restore them here if mod_unload is true!!
function ChaosEffect:onEffectEnd(mod_unload) end

function ChaosEffect:update() end

function ChaosEffect:canRunEffect() return true end

-- Marks the effect for removal
function ChaosEffect:stopEffect() self.duration = -1 end

return ChaosEffect