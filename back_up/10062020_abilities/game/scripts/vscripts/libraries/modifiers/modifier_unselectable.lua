modifier_unselectable = class({})

function modifier_unselectable:CheckState() 
    local state = {
      [MODIFIER_STATE_UNSELECTABLE] = true,
    }
    return state
  end