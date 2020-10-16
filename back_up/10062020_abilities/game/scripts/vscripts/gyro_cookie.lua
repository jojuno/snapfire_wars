gyro_cookie = class({})

local gyro_cookie_radius = 700

--salvo cookie
--small cookies with smaller jumps and stuns
--launch randomly
--level from 5/10/15/20


function gyro_cookie:OnSpellStart()
    --emit sound on unit
    local caster = self:GetCaster()
    local casterPt = caster:GetAbsOrigin()
    --first argument: team number for teamFilter purposes
    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 
    gyro_cookie_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY + DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE,
    FIND_ANY_ORDER, false)
    --if there's no units found, it still exists, but it's empty
    --for i = 0, 2 do
        if #units>0 then
            for key, unit in pairs(units) do
                if unit == caster then
                    --nothing
                else
                    local info = 
                    {
                        Target = unit,
                        Source = caster,
                        Ability = self,	
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
        end
    --end
end

function gyro_cookie:OnProjectileHit(hTarget, vLocation)
    local ability = hTarget:FindAbilityByName("snapfire_firesnap_cookie_arrow")
    print("[bomb_cookie:OnProjectileHit] ability's name: " .. ability:GetAbilityName())
    hTarget:SetCursorCastTarget(hTarget)
    ability:OnSpellStart()
    return true
end