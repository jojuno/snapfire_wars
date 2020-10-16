modifier_invulnerable = class({})

function modifier_invulnerable:CheckState()
	local state = {
	[MODIFIER_STATE_INVULNERABLE] = true,
	}
	return state
end

function modifier_invulnerable:OnCreated( kv )
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/omniknight/omni_sacred_light_head/omni_ambient_sacred_light.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( 0, 0, 0 ) )
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )
	end
end

function modifier_invulnerable:OnDestroyed( kv )
	if IsServer() then
		ParticleManager:DestroyParticle(self.nFXIndex, false)
	end
end