local MessWithCOLORSEffect, super = Class(ChaosEffect, "messCOLORS_effect")

function MessWithCOLORSEffect:onEffectStart(in_battle)
	local mix = {}
	for i,color in ipairs(TableUtils.getKeys(COLORS)) do
		mix[color] = COLORS[color]
	end
	table.shuffle(mix)
	for i,color in ipairs(TableUtils.getKeys(COLORS)) do
		COLORS[color] = mix[color]
	end
end

return MessWithCOLORSEffect