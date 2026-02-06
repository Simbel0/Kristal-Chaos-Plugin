local NPCsAttaccEffect, super = Class(ChaosEffect, "npcAreEnemies_effect")

function NPCsAttaccEffect:onEffectStart(in_battle)
    for i,npc in ipairs(Game.world.stage:getObjects(NPC)) do
        npc:convertToEnemy()
    end
end

function NPCsAttaccEffect:canRunEffect()
    return Game.world and Game.world.stage
end

return NPCsAttaccEffect