local BecomeSignEffect, super = Class(ChaosEffect, "sign_effect")

function BecomeSignEffect:onEffectStart(in_battle)
	TableUtils.pick(TableUtils.mergeMany({Game.world.player}, Game.world.followers)):setActor("sign")
end

return BecomeSignEffect