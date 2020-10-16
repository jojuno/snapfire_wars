summon_mortimer = class({})

function summon_mortimer:OnSpellStart()
    print("here")
    local caster = self:GetCaster()
    local casterPt = caster:GetAbsOrigin()
    local unit = CreateUnitByName("mortimer", casterPt, true, caster, caster, caster:GetTeamNumber())
    unit:SetControllableByPlayer(caster:GetPlayerID(), true)
    unit:SetBaseMoveSpeed(0)
    unit.cookie = false
end

