modifier_bonus_health = class({})


function modifier_bonus_health:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS

	}

	return funcs
end

function modifier_bonus_health:OnCreated( kv )
    self:GetParent()
end