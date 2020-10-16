salvo_cookie = class({})

local salvo_cookie_radius = 800

--salvo cookie
--small cookies with smaller jumps and stuns
--launch randomly
--level from 5/10/15/20


function salvo_cookie:OnSpellStart()
    --emit sound on unit
    local caster = self:GetCaster()
    local casterPt = caster:GetAbsOrigin()
    --first argument: team number for teamFilter purposes

    --spawn fake unit
    local salvo_cookie_unit = CreateUnitByName("salvo_cookie_unit", casterPt, true, caster, caster, caster:GetTeamNumber())
    
    
    --find units in a radius
    local units = FindUnitsInRadius(salvo_cookie_unit:GetTeamNumber(), casterPt, nil, 
    salvo_cookie_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY + DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE,
    FIND_ANY_ORDER, false)
    
    --fake unit casts salvo cookie on unit
    for i = 0, 2 do
        if #units>0 then
            for key, unit in pairs(units) do
                Timers:CreateTimer({
                    endTime = 0.1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
                    callback = function()
                        local salvo_cookie = salvo_cookie_unit:FindAbilityByName("snapfire_firesnap_cookie_salvo")
                        salvo_cookie_unit:SetCursorCastTarget(unit)
                        salvo_cookie:OnSpellStart()
                    end
                  })

            end
        end
    end
    salvo_cookie_unit:ForceKill(false)



end

-- function gyro_cookie:OnProjectileHit(hTarget, vLocation)
--     --hTarget:AddAbility("snapfire_firesnap_cookie_salvo")
--     local ability = hTarget:FindAbilityByName("snapfire_firesnap_cookie_salvo")
--     print("[bomb_cookie:OnProjectileHit] ability's name: " .. ability:GetAbilityName())
--     hTarget:SetCursorCastTarget(hTarget)
--     ability:OnSpellStart()
--     --hTarget:RemoveAbility("snapfire_firesnap_cookie_salvo")
--     return true
-- end