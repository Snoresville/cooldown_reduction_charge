cd_lua = cd_lua or class({})

function cd_lua:GetTexture() return "item_octarine_core" end -- get the icon from a different ability

function cd_lua:IsPermanent() return true end
function cd_lua:RemoveOnDeath() return false end
function cd_lua:IsHidden() return false end 	-- we can hide the modifier
function cd_lua:IsDebuff() return false end 	-- make it red or green

function cd_lua:GetAttributes()
	return 0
		+ MODIFIER_ATTRIBUTE_PERMANENT           -- Modifier passively remains until strictly removed. 
		-- + MODIFIER_ATTRIBUTE_MULTIPLE            -- Allows modifier to stack with itself. 
		-- + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE -- Allows modifier to be assigned to invulnerable entities. 
end

function cd_lua:OnCreated()
    if IsClient() then return end
    self:StartIntervalThink(BUTTINGS.CHARGE_100/100)
end

function cd_lua:OnIntervalThink()
    self:IncrementStackCount()
end

function cd_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}
	return funcs
end

function cd_lua:GetModifierPercentageCooldown()
    if self.lock then return 0 end
    return self:GetStackCount()
end

function cd_lua:OnAbilityFullyCast(kv)
    self.lock = true
    local cooldown_reduction = (1 - self:GetParent():GetCooldownReduction()) * 100
    self.lock = false

    local stacks_spent = math.max(math.min(self:GetStackCount(), 100) - cooldown_reduction, 0)

    self:SetStackCount(self:GetStackCount() - stacks_spent)
end

