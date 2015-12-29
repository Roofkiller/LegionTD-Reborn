EXPORTS = {}

EXPORTS.Init = function( self )
	self:SetContextThink( "init_think", function()
		self:GetAbilityByIndex(1):SetLevel(1)
		self.aiThink = aiThinkStandardSkill
		self.CheckIfHasAggro = CheckIfHasAggro
		self.Skill = UseSkillNoTarget
		self.ability = self:GetAbilityByIndex(1)
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_thunderelemental.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end

return EXPORTS