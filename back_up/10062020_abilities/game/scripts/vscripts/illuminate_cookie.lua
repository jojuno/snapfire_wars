illuminate_cookie = class({})
--LinkLuaModifier("illuminate_cookie_modifier", LUA_MODIFIER_MOTION_NONE)

function illuminate_cookie:OnSpellStart()
    --illuminate particle
    --casts cookie on hit
    print("here")
    local caster = self:GetCaster()
    --A Liner Projectile must have a table with projectile info
    local cursorPt = self:GetCursorPosition()
    local casterPt = caster:GetAbsOrigin()
    local direction = cursorPt - casterPt
    direction = direction:Normalized()
    local info = 
    { 
        Ability = self,
        EffectName = "particles/econ/items/keeper_of_the_light/kotl_ti7_illuminate/kotl_ti7_illuminate.vpcf", --particle effect
        --EffectName = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_projectile.vpcf", --particle effect
        vSpawnOrigin = caster:GetAbsOrigin(),
        fDistance = 2000,
        fStartRadius = 500,
        fEndRadius = 500,
        Source = caster,
        --bHasFrontalCone = false,
        --bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 10.0,
        bDeleteOnHit = true,
        vVelocity = direction * 1500,
        bProvidesVision = true,
        iVisionRadius = 500,
        iVisionTeamNumber = caster:GetTeamNumber()
    }
    projectile = ProjectileManager:CreateLinearProjectile(info)
end

function illuminate_cookie:OnProjectileHit(hTarget, vLocation)
    if hTarget == nil then
        print("arrow expired")
    else
        print("arrow hit: " .. hTarget:GetName())
        print("hTarget: ")
        PrintTable(hTarget)
        print("caster: ")
        PrintTable(caster)
        if hTarget == self:GetCaster() then
            --skip
        else
            local ability = hTarget:GetAbilityByIndex(8)
            --use next two lines to make centaur cast spells
            hTarget:SetCursorCastTarget(hTarget)
            --this will ignore cooldown and status (like stun) and cast the spell
            ability:OnSpellStart()
            --clear cooldown
            --hTarget:AddNewModifier(self:GetCaster(), self, "arrow_cookie_modifier", { duration = 5.0 })
        end
    end
    return false
end
