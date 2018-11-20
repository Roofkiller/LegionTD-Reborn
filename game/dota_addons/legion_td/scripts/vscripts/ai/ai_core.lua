STANDARD_THINK_TIME = 0.1
OPTIMAL_SEARCH_RANGE = 200
MAX_SAME_DATA = 15
EXPORTS = {}

LinkLuaModifier("modifier_unit_freeze_lua", "abilities/modifier_unit_freeze_lua.lua", LUA_MODIFIER_MOTION_NONE)

EXPORTS.Init = function(self)
    self:SetContextThink(
        "init_think",
        function()
            self.aiThink = aiThinkStandard
            self.NextWayPoint = NextWayPoint
            self.Unstuck = Unstuck
            self:Unstuck()
            self:SetContextThink("ai_standard.aiThink", Dynamic_Wrap(self, "aiThink"), 0)
        end,
        0
    )
end

function aiThinkStandard(self)
    if
        SafeCall(
            function()
                if not self:IsAlive() then
                    return
                end
                if
                    self:HasModifier("modifier_unit_freeze_lua") or GameRules:IsGamePaused() or
                        self:HasModifier("modifier_invulnerable")
                 then
                    return STANDARD_THINK_TIME
                end
                if self.wayStep and ((self:GetAbsOrigin() - self.waypoints[self.wayStep]):Length2D() < 50) then -- we've hit a waypoint
                    return self:NextWayPoint()
                end

                if self.wayStep and not GridNav:CanFindPath(self:GetAbsOrigin(), self.waypoints[self.wayStep]) then
                    self:SetAbsOrigin(self.waypoints[self.wayStep])
                end

                if CheckStuck(self) then
                    return self:Unstuck()
                end
            end
        )
     then
        return STANDARD_THINK_TIME
    else
        return nil
    end
end

--[[function aiThinkStandardBuff(self)
if not self:IsAlive() and not self:HasModifier("modifier_invulnerable") then
return
end
if self:HasModifier("modifier_unit_freeze_lua") or GameRules:IsGamePaused() then
return STANDARD_THINK_TIME
end
if self.ability:IsCooldownReady() then
return self:Skill()
end
if self.wayStep and ((self:GetAbsOrigin() - self.waypoints[self.wayStep]):Length2D() < 50) then -- we've hit a waypoint
return self:NextWayPoint()
end
if self:IsIdle() and not self:SkillTrigger() then
return self:Unstuck()
end
return STANDARD_THINK_TIME
end]]
--
function aiThinkStandardSkill(self)
    local thinkTime
    local callComplete = SafeCall(
        function()
            if not self:IsAlive() then
                return
            end
            if
                self:HasModifier("modifier_unit_freeze_lua") or GameRules:IsGamePaused() or
                    self:HasModifier("modifier_invulnerable")
             then
                thinkTime = STANDARD_THINK_TIME
                return
            end

            for i, v in ipairs(self.abilities) do
                if v:IsCooldownReady() and v:SkillTrigger(self) then
                    thinkTime = v.Skill(self, v)
                    return
                end
            end

            if self.wayStep and ((self:GetAbsOrigin() - self.waypoints[self.wayStep]):Length2D() < 50) then -- we've hit a waypoint
                thinkTime = self:NextWayPoint()
                print(thinkTime)
                return
            end

            if self.wayStep and not GridNav:CanFindPath(self:GetAbsOrigin(), self.waypoints[self.wayStep]) then
                self:SetAbsOrigin(self.waypoints[self.wayStep])
            end

            if CheckStuck(self) then
                thinkTime = self:Unstuck()
                return
            end

            thinkTime = STANDARD_THINK_TIME
            return
        end
    )
    if callComplete and thinkTime then
        return thinkTime
    else
        return nil
    end
end

function CheckStuck(self)
    -- Collect data
    local position = self:GetAbsOrigin()
    local data = {
        x = position.x,
        y = position.y,
        z = position.z,
        hp = self:GetHealth(),
        mana = self:GetMana()
    }
    -- Calculate new index
    local dataArray = self.dataArray or {}
    local ind = self.currentDataIndex or 0
    ind = ind + 1
    if ind > MAX_SAME_DATA then
        ind = 1
    end
    local prevData = dataArray[ind]
    -- Comparing old with new data
    local result = prevData ~= nil
    if prevData ~= nil then
        for key, value in pairs(data) do
            result = result and prevData[key] == value
        end
    end
    -- Setting new data
    dataArray[ind] = data
    self.dataArray = dataArray
    self.currentDataIndex = ind
    -- Catch simple cases first
    if self:IsIdle() then
        return true
    end
    if self:IsStunned() or self:IsRooted() or CheckIfHasAggro(nil, self) then
        return false
    end
    -- Return data equality
    return result
end

function UseSkillNoTarget(entity, ability)
    entity:CastAbilityNoTarget(ability, -1)
    return 1
end

function UseSkillOnTargetPosition(entity, ability)
    entity:CastAbilityOnPosition(entity:GetAggroTarget():GetAbsOrigin(), ability, -1)
    return 1
end

function UseSkillOnTarget(entity, ability)
    entity:CastAbilityOnTarget(entity:GetAggroTarget(), ability, -1)
    return 1
end

function UseSkillOnSelf(entity, ability)
    entity:CastAbilityOnTarget(entity, ability, -1)
    return 1
end

function UseSkillTargetPositionOptimalRadius(entity, ability)
    local Radius = ability:GetCastRange() + OPTIMAL_SEARCH_RANGE
    local Units =
        FindUnitsInRadius(
        entity:GetTeamNumber(),
        entity:GetAbsOrigin(),
        nil,
        Radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST,
        false
    )
    local TargetUnit
    local mostUnits = 0

    for i, v in pairs(Units) do
        local Radius = ability:GetSpecialValueFor("radius") or ability.CustomAffectRadius
        if not Radius then
            print("Tried to run UseSkillTargetPositionOptimalRadius without radius; returning")
            return 10
        end
        local Units =
            FindUnitsInRadius(
            entity:GetTeamNumber(),
            v:GetAbsOrigin(),
            nil,
            Radius,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_CLOSEST,
            false
        )
        if #Units > mostUnits then
            mostUnits = #Units
            TargetUnit = v
        end
    end

    if TargetUnit == nil then
        print("UseSkillTargetPositionOptimalRadius: Couldn't find target unit")
        return STANDARD_THINK_TIME
    end
    entity:CastAbilityOnPosition(TargetUnit:GetAbsOrigin(), ability, -1)
    return 1
end

function UseSkillTargetOptimalRadius(entity, ability)
    local Radius = ability:GetCastRange() + OPTIMAL_SEARCH_RANGE
    local Units =
        FindUnitsInRadius(
        entity:GetTeamNumber(),
        entity:GetAbsOrigin(),
        nil,
        Radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST,
        false
    )
    local TargetUnit
    local mostUnits = 0

    for i, v in pairs(Units) do
        local Radius = ability:GetSpecialValueFor("radius") or ability.CustomAffectRadius
        if not Radius then
            print("Tried to run UseSkillTargetOptimalRadius without radius; returning")
            return 10
        end
        local Units =
            FindUnitsInRadius(
            entity:GetTeamNumber(),
            v:GetAbsOrigin(),
            nil,
            Radius,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_CLOSEST,
            false
        )
        if #Units > mostUnits then
            mostUnits = #Units
            TargetUnit = v
        end
    end

    if TargetUnit == nil then
        print("UseSkillTargetOptimalRadius: Couldn't find target unit")
        return STANDARD_THINK_TIME
    end
    entity:CastAbilityOnTarget(TargetUnit, ability, -1)
    return 1
end

function UseSkillTargetMostEHPPhysical(entity, ability)
    local Radius = ability:GetCastRange() + OPTIMAL_SEARCH_RANGE
    local Units =
        FindUnitsInRadius(
        entity:GetTeamNumber(),
        entity:GetAbsOrigin(),
        nil,
        Radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST,
        false
    )
    local TargetUnit
    local mostEHP = 0

    for i, v in pairs(Units) do
        local armor = v:GetPhysicalArmorValue()
        local EHP = v:GetHealth() / (1 - 0.06 * armor / (1 + (0.06 * math.abs(armor))))
        -- from http://dota2.gamepedia.com/Armor#Damage_multiplier
        if EHP > mostEHP then
            TargetUnit = v
            mostEHP = EHP
        end
    end

    if TargetUnit == nil then
        print("UseSkillTargetMostEHPPhysical: Couldn't find target unit")
        return STANDARD_THINK_TIME
    end
    entity:CastAbilityOnTarget(TargetUnit, ability, -1)
    return 1
end

function NextWayPoint(self)
    --	print("lane creep hit waypoint " .. self.wayStep)
    if self.wayStep < #self.waypoints then
        self.wayStep = self.wayStep + 1
        ExecuteOrderFromTable(
            {
                UnitIndex = self:entindex(),
                OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
                TargetIndex = 0, --Optional.  Only used when targeting units
                AbilityIndex = 0, --Optional.  Only used when casting abilities
                Position = self.waypoints[self.wayStep], --Optional.  Only used when targeting the ground
                Queue = 0 --Optional.  Used for queueing up abilities
            }
        )
    end

    return STANDARD_THINK_TIME
end

function Unstuck(self)
    if self.wayStep then -- is this a wave/send creep?
        --print ("Unsticking unit with .WayStep")
        self:Stop()
        ExecuteOrderFromTable(
            {
                UnitIndex = self:entindex(),
                OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
                TargetIndex = 0, --Optional.  Only used when targeting units
                AbilityIndex = 0, --Optional.  Only used when casting abilities
                Position = self.waypoints[self.wayStep], --Optional.  Only used when targeting the ground
                Queue = 0 --Optional.  Used for queueing up abilities
            }
        )
    elseif self.nextTarget then
        --print ("Unsticking unit with .nextTarget: " .. self.nextTarget.x .. ", " .. self.nextTarget.y)
        self:Stop()
        ExecuteOrderFromTable(
            {
                UnitIndex = self:entindex(),
                OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
                TargetIndex = 0, --Optional.  Only used when targeting units
                AbilityIndex = 0, --Optional.  Only used when casting abilities
                Position = self.nextTarget, --Optional.  Only used when targeting the ground
                Queue = 0 --Optional.  Used for queueing up abilities
            }
        )
    end
    return 1.0
end

function CheckIfHasAggroInRange(ability, entity)
    AggroTarget = entity:GetAggroTarget()
    if AggroTarget ~= nil then
        if CalcDistanceBetweenEntityOBB(entity, AggroTarget) < ability.SkillUseRange then
            return true
        end
    end
    return false
end

function CheckIfHasAggro(ability, entity)
    return entity:GetAggroTarget() ~= nil
end

function CheckAbilityRange(ability, entity)
    local Radius = ability:GetCastRange()
    local Units =
        FindUnitsInRadius(
        entity:GetTeamNumber(),
        entity:GetAbsOrigin(),
        nil,
        Radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_BASIC,
        0,
        0,
        false
    )

    if #Units > 0 then
        return true
    end
    return false
end

return EXPORTS
