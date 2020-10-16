summon_cookie = class({})

function summon_cookie:OnSpellStart()
    
    print("here")
    local caster = self:GetCaster()
    local casterPt = caster:GetAbsOrigin()
    for i = 0, 2 do
        local unit = CreateUnitByName("cookie_monster", casterPt, true, caster, caster, caster:GetTeamNumber())
        unit:SetControllableByPlayer(caster:GetPlayerID(), true)
        --attach sparkles
        --attack with bubbles
        --attack with mud
    end
end

