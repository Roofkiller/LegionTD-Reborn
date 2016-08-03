EXPORTS = {}

EXPORTS.Init = function( self )
	self:SetContextThink( "init_think", function()
		self.aiThink = aiThinkStandardSkill
		self.CheckIfHasAggro = CheckIfHasAggro
		self.Skill = UseSkillOnTarget
		--self.ability = self:FindAbilityByName("militia_shield_bash")
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_imp18.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end

return EXPORTS
