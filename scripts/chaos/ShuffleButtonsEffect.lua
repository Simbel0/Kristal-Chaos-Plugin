local ShuffleButtonsEffect, super = Class(ChaosEffect, "battleButtonsShuffle_effect")

function ShuffleButtonsEffect:onEffectStart(in_battle)
	local fix_buttons_pos = Utils.random() < 0.5
	for i,box in ipairs(Game.battle.battle_ui.action_boxes) do
		local buttons_x
		if fix_buttons_pos then
			buttons_x = {}
			for ii, button in ipairs(box.buttons) do
				table.insert(buttons_x, button.x)
			end
		end

		table.shuffle(box.buttons)

		if fix_buttons_pos then
			for ii, button in ipairs(box.buttons) do
				button.x = buttons_x[ii]
			end
		end
	end
end

function ShuffleButtonsEffect:canRunEffect()
	return Game.battle and Game.battle.battle_ui
end

return ShuffleButtonsEffect