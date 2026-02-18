local GiveItemEffect, super = Class(ChaosEffect, "giveItem_effect")

function GiveItemEffect:onEffectStart(in_battle)
	local success, text = Game.inventory:tryGiveItem(TableUtils.pick(TableUtils.getKeys(Registry.items)))
	if success and not in_battle and (Game.world and Game.world.stage and not Game.world:hasCutscene()) then
		Game.world:showText(text)
	end
end

return GiveItemEffect