local OverlapMusicEffect, super = Class(ChaosEffect, "toomuchmusic_effect")

function OverlapMusicEffect:onEffectStart(in_battle)
    local musics = Chaos:getAsset("overlap_musics")
    if not musics then
        Chaos:registerAsset("overlap_musics", {})
        musics = Chaos:getAsset("overlap_musics")
    end

    table.insert(musics, Music(in_battle and Game.battle.encounter.music or Game.world.map.music))
    if #musics > 10 then
        table.remove(musics, 1):remove()
    end
end

function OverlapMusicEffect:canRunEffect()
    return (Game.battle and Game.battle.encounter.music) or ((Game.world and Game.world.map) and Game.world.map.music)
end

return OverlapMusicEffect