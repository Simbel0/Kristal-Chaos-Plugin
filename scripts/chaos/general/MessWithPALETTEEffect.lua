local MessWithPALETTEEffect, super = Class(ChaosEffect, "messPALETTE_effect")

local PALETTE_IDS = {
	"battle_mercy_bg",
	"battle_mercy_text",
	"battle_attack_lines",

	"world_fill",
	"world_border",
	"world_text",
	"world_text_selected",
	"world_text_hover",
	"world_text_rebind",
	"world_text_shadow",
	"world_text_unusable",
	"world_gray",
	"world_dark_gray",
	"world_light_gray",
	"world_header",
	"world_header_selected",
	"world_save_other",
	"world_ability_icon",

    "action_strip",
	"action_fill",
	"action_health_bg",
	"action_health_text_down",
	"action_health_text_low",
	"action_health_text",
	"action_health",

    "tension_back",
	"tension_decrease",
	"tension_fill",
	"tension_max",
	"tension_maxtext",
	"tension_desc",

    "tension_back_reduced",
	"tension_decrease_reduced",
	"tension_fill_reduced",
	"tension_max_reduced"
}

function MessWithPALETTEEffect:onEffectStart(in_battle)
	if not Chaos.FAKE_PALETTE then
		Chaos.FAKE_PALETTE = {}
		for i,id in ipairs(PALETTE_IDS) do
			if PALETTE[id] then
				Chaos.FAKE_PALETTE[id] = PALETTE[id]
			end
		end

		HookSystem.hook(Mod, "getPaletteColor", function(orig, self, i)
			return Chaos.FAKE_PALETTE[i]
		end)
	end
	table.shuffle(Chaos.FAKE_PALETTE)
end

return MessWithPALETTEEffect