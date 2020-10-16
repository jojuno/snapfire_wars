--spawn projectile
--record time
--projectile hits target
--record time
--take time it takes for projectile to travel
--cast ability when projectile expires
--speed = distance over time
--CalcClosestPointOnEntityOBB
--after object "hit" the target, cast ability after the amount of time

local dummy
local projectileCreated
local projectileDestroyed
local projectileLifetime
local distanceBetweenCasterAndProjectile
local projectileHit
local timeTraveled
local start

start = GameRules:GetGameTime()
timeTraveled = start
--local endTime = round(GameRules:GetGameTime() + COUNT_DOWN_FROM)

distanceBetweenCasterAndProjectile = CalcDistanceBetweenEntityOBB(caster, dummy)
local info = 
{
    Target = dummy,
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

projectileCreated = GameRules:GetGameTime()

GameRules:GetGameModeEntity():SetThink(function ()
    if projectileHit then
        timeTraveled = timeTraveled - start
        print("[bomb_cookie:OnProjectileHit] timeTraveled: " .. timeTraveled)
    else

        timeTraveled = timeTraveled + 0.06
        return 0.06
    end
end)

function bomb_cookie:OnProjectileHit(hTarget, vLocation)
    projectileHit = true
    
    projectileDestroyed = GameRules:GetGameTime()
    projectileLifetime = projectileDestroyed - projectileCreated
    print("[bomb_cookie:OnProjectileHit] time it took for projectile to disappear: " .. projectileLifetime)
    print("[bomb_cookie:OnProjectileHit] distance between the caster and the projectile: " .. distanceBetweenCasterAndProjectile)
    print("[bomb_cookie:OnProjectileHit] speed of projectile: " .. distanceBetweenCasterAndProjectile / timeTraveled)



return true
end