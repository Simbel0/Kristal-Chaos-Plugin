local MusicInsanityEffect, super = Class(ChaosEffect, "music_effect")

function MusicInsanityEffect:onEffectStart(in_battle)
	(in_battle and Game.battle or Game.world).music:setPitch(Utils.random(0, 2))
end

return MusicInsanityEffect