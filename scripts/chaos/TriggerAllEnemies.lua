local TriggerAllEnemiesEffect, super = Class(ChaosEffect, "enemies_effect")

function TriggerAllEnemiesEffect:onEffectStart(in_battle)
    for i,enemy in ipairs(Game.stage:getObjects(ChaserEnemy)) do
        enemy.path = nil
        enemy.can_chase = true

        enemy.chase_speed = enemy.chase_speed * 2
        if enemy.chase_max then
            enemy.chase_max = enemy.chase_max * 4
        end
        if enemy.chase_accel then
            enemy.chase_accel = enemy.chase_accel * 10
        end

        enemy:alert(nil, {callback=function()
            enemy.chasing = true
            enemy.noclip = false
            enemy:setAnimation("chasing")
        end})
        enemy:setAnimation("alerted")
        enemy:onAlerted()
    end
end

return TriggerAllEnemiesEffect