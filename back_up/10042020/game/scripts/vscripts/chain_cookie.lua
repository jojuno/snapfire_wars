chain_cookie = class({})
LinkLuaModifier("chain_cookie_modifier", LUA_MODIFIER_MOTION_NONE)

--first target casts cookie on herself
--repeat a set number of times
function chain_cookie:OnSpellStart()
    if GameMode.chainCookieBounces == 0 then
        GameMode.chainCookieBounces = 5
        --break
    else
        --cast a cookie on a target
        local caster = self:GetCaster()
        local target = self:GetCursorTarget()
        local info = 
        {
            Target = target,
            Source = caster,
            Ability = caster:FindAbilityByName("chain_cookie"),	
            EffectName = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_projectile.vpcf",
            iMoveSpeed = 1000,
            vSourceLoc= caster:GetAbsOrigin(),                -- Optional (HOW)
            bDrawsOnMinimap = false,                          -- Optional
                bDodgeable = false,                                -- Optional
                bIsAttack = false,                                -- Optional
                bVisibleToEnemies = true,                         -- Optional
                bReplaceExisting = false,                         -- Optional
                flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
            bProvidesVision = false,                           -- Optional
            iVisionRadius = 400,                              -- Optional
            iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
        }
        projectile = ProjectileManager:CreateTrackingProjectile(info)
    end
end


function chain_cookie:OnProjectileHit(hTarget, vLocation)
    print("[chain_cookie:OnProjectileHit] called")
    GameMode.chainCookieBounces = GameMode.chainCookieBounces - 1
    local ability = hTarget:FindAbilityByName("snapfire_firesnap_cookie_arrow")
    hTarget:SetCursorCastTarget(hTarget)
    ability:OnSpellStart()
    local cookie_multi_range = 600
    local units = FindUnitsInRadius(DOTA_TEAM_CUSTOM_1 +DOTA_TEAM_CUSTOM_2+DOTA_TEAM_CUSTOM_3+DOTA_TEAM_CUSTOM_4
    +DOTA_TEAM_CUSTOM_5+DOTA_TEAM_CUSTOM_6+DOTA_TEAM_CUSTOM_7+DOTA_TEAM_CUSTOM_8 , hTarget:GetAbsOrigin(), nil, 
    cookie_multi_range, DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE,
    FIND_ANY_ORDER, false)
    print("[chain_cookie:OnProjectileHit] units: ")
    PrintTable(units)
    for key, unit in pairs(units) do
        print("[chain_cookie:OnProjectileHit] unit's key: ")
        print(key)
        print("[chain_cookie:OnProjectileHit] unit's name: ")
        print(unit:GetUnitName())
    end
    --if units[1] is itself then
        --find another target
    --bounce a limited number of times
    --unit is in the found units, but it may not be the first one
    if units[1] == hTarget then
        print("[chain_cookie:OnProjectileHit] units[1] == hTarget")
        if units[2] == nil then
            print("[chain_cookie:OnProjectileHit] units[2] == nil")
            GameMode.chainCookieBounces = 0
        else
            print("[chain_cookie:OnProjectileHit] units[2] not == nil")
            hTarget:SetCursorCastTarget(units[2])
        end
    else
        print("[chain_cookie:OnProjectileHit] units[1] not == hTarget")
        hTarget:SetCursorCastTarget(units[1])
    end
    ability = hTarget:FindAbilityByName("chain_cookie")
    ability:OnSpellStart()
    -- --caster:CastAbilityOnTarget(target, cookie, -1) -- playerIndex?
    -- --find targets in an area around the target
    -- --does self.unit:GetTeam() find everybody?
    -- local multiTarget = nil
    -- local units = FindUnitsInRadius(hTarget:GetTeam(), hTarget:GetAbsOrigin(), nil, 
    -- cookie_multi_range, DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE,
    -- FIND_ANY_ORDER, false)
    -- if #units > 0 then
    --     multiTarget = units[1]
    --     while multiTarget == hTarget do
    --         units = FindUnitsInRadius(hTarget:GetTeam(), hTarget:GetAbsOrigin(), nil, 
    --         cookie_multi_range, DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE,
    --         FIND_ANY_ORDER, false)
    --     end
    -- end
    -- print("[chain_cookie:OnSpellStart] hTarget: ")
    -- PrintTable(hTarget)
    -- print("[chain_cookie:OnSpellStart] multiTarget: ")
    -- PrintTable(multiTarget)
    -- hTarget:SetCursorCastTarget(multiTarget)
    -- hTarget:FindAbilityByName("snapfire_firesnap_cookie_arrow"):OnSpellStart()
    -- -- local units2 = FindUnitsInRadius(self.multiTarget:GetTeam(), self.multiTarget:GetAbsOrigin(), nil, 
    -- -- cookie_multi_range, DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE,
    -- -- FIND_ANY_ORDER, false)
    -- -- if #units2 > 0 then
    -- --     self.multiTarget.multiTarget = units2[1]
    -- -- end
    -- -- local multiTarget_cookie = self.multiTarget:GetAbilityByIndex(8)
    -- -- self.multiTarget:CastAbilityOnTarget(self.multiTarget.multiTarget, multiTarget_cookie, self.multiTarget:GetPlayerOwnerID())
    -- local info = 
    -- {
    --     Target = multiTarget,
    --     Source = hTarget,
    --     Ability = caster:GetAbilityByIndex(8),	
    --     EffectName = "some_particle_effect",
    --     iMoveSpeed = 1000,
    --     vSourceLoc= caster:GetAbsOrigin(),                -- Optional (HOW)
    --     bDrawsOnMinimap = false,                          -- Optional
    --         bDodgeable = false,                                -- Optional
    --         bIsAttack = false,                                -- Optional
    --         bVisibleToEnemies = true,                         -- Optional
    --         bReplaceExisting = false,                         -- Optional
    --         flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
    --     bProvidesVision = false,                           -- Optional
    --     iVisionRadius = 400,                              -- Optional
    --     iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
    -- }
    -- projectile = ProjectileManager:CreateTrackingProjectile(info)
    return true
end



