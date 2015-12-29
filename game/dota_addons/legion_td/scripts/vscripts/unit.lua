if Unit == nil then
  Unit = class({})
end



ai_standard = require('ai/ai_core')
--Naturebuilder AI
ai_broodmother = require('ai/naturebuilder/ai_broodmother')
ai_bigcentaur = require('ai/naturebuilder/ai_bigcentaur')
--Elementalbuilder AI
ai_earthgod = require('ai/elementalbuilder/ai_earthgod')
ai_fireelemental = require('ai/elementalbuilder/ai_fireelemental')
ai_firegod = require('ai/elementalbuilder/ai_firegod')
ai_firewarrior = require('ai/elementalbuilder/ai_firewarrior')
ai_thunderelemental = require('ai/elementalbuilder/ai_thunderelemental')
ai_thundergod = require('ai/elementalbuilder/ai_thundergod')
ai_thunderwarrior = require('ai/elementalbuilder/ai_thunderwarrior')
ai_voidelemental = require('ai/elementalbuilder/ai_voidelemental')
ai_voidgod = require('ai/elementalbuilder/ai_voidgod')
ai_watergod = require('ai/elementalbuilder/ai_watergod')
ai_waterwarrior = require('ai/elementalbuilder/ai_waterwarrior')
--Humanbuilder AI
ai_militia = require('ai/humanbuilder/ai_militia')
ai_footman = require('ai/humanbuilder/ai_footman')
ai_lieutenant = require('ai/humanbuilder/ai_lieutenant')
ai_soldier = require('ai/humanbuilder/ai_soldier')
ai_general = require('ai/humanbuilder/ai_general')
ai_spearman = require('ai/humanbuilder/ai_spearman')



function Unit.new(npcclass, position, owner, foodCost, goldCost)
  local self = Unit()
  self.buytime = GameRules:GetGameTime()
  self.goldCost = goldCost
  self.foodCost = foodCost
  self.npcclass = npcclass
  self.spawnposition = position
  self.owner = owner
  self.player = owner.player
  self.target = self.player.lane.unitWaypoint
  self.nextTarget = self.target:GetAbsOrigin()
  self.nextTarget.x = self.spawnposition.x
  table.insert(self.player.units, self)
  self:Spawn()
end



function Unit:Spawn()
  self.npc = CreateUnitByName(self.npcclass, self.spawnposition, true, nil,
  self.owner, self.owner:GetTeamNumber())
  if self.spawnposition.y > 0 then
    self.npc:SetAngles(0, 90, 0)
  else
    self.npc:SetAngles(0, 270, 0)
  end
  self.npc.unit = self
  self.npc.player = self.player
  self.npc.nextTarget = self.target:GetAbsOrigin()
  self.npc.nextTarget.x = self.spawnposition.x
  self:Lock()
end



function Unit.ApplyAI(unit)
  local name = unit:GetUnitName()
  if name == "tower_naturebuilder_broodmother" then ai_broodmother.Init(unit)
  elseif name == "tower_naturebuilder_big_centaur" then ai_bigcentaur.Init(unit)
  elseif name == "tower_elementalbuilder_earthgod" then ai_earthgod.Init(unit)
  elseif name == "tower_elementalbuilder_fireelemental" then ai_fireelemental.Init(unit)
  elseif name == "tower_elementalbuilder_firegod" then ai_firegod.Init(unit)
  elseif name == "tower_elementalbuilder_firewarrior" then ai_firewarrior.Init(unit)
  elseif name == "tower_elementalbuilder_thunderelemental" then ai_thunderelemental.Init(unit)
  elseif name == "tower_elementalbuilder_thundergod" then ai_thundergod.Init(unit)
  elseif name == "tower_elementalbuilder_thunderwarrior" then ai_thunderwarrior.Init(unit)
  elseif name == "tower_elementalbuilder_voidelemental" then ai_voidelemental.Init(unit)
  elseif name == "tower_elementalbuilder_voidgod" then ai_voidgod.Init(unit)
  elseif name == "tower_elementalbuilder_watergod" then ai_watergod.Init(unit)
  elseif name == "tower_elementalbuilder_waterwarrior" then ai_waterwarrior.Init(unit)
  elseif name == "tower_humanbuilder_militia" then ai_militia.Init(unit)
  else ai_standard.Init(unit)
  end
end



function Unit:RemoveNPC()
  if not self.npc:IsNull() and self.npc:IsAlive() then
    self.npc:ForceKill(false)
  end
end



function Unit:Respawn()
  self:RemoveNPC()
  self:Spawn()
end



function Unit:ResetPosition()
  if not self.npc:IsNull() and self.npc:IsAlive() then
    FindClearSpaceForUnit(self.npc, self.spawnposition, true)
    self:Unlock()
  end
end



function Unit:Unlock()
  if self.npc and not self.npc:IsNull() and self.npc:IsAlive() then
    self.npc:RemoveModifierByName("modifier_stunned")
    self.npc:RemoveModifierByName("modifier_invulnerable")
    self.npc:SetControllableByPlayer(-1, false)
    self.npc:Stop()
    Timers:CreateTimer(0.5, function ()
      local pos = self.npc.nextTarget
      pos.x = self.spawnposition.x
      ExecuteOrderFromTable({
        UnitIndex = self.npc:entindex(), 
        OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
        TargetIndex = 0, --Optional.  Only used when targeting units
        AbilityIndex = 0, --Optional.  Only used when casting abilities
        Position = pos, --Optional.  Only used when targeting the ground
        Queue = 0 --Optional.  Used for queueing up abilities
      })
      self.ApplyAI(self.npc)
    end)
  end
end



function Unit:Lock()
  if not self.npc:IsNull() and self.npc:IsAlive() then
    self.npc:AddNewModifier(nil, nil, "modifier_invulnerable", {})
    self.npc:AddNewModifier(nil, nil, "modifier_stunned", {})
    self:GivePlayerControl()
  end
end



function Unit:GivePlayerControl()
  if self.player:IsActive() then
    self.npc:SetControllableByPlayer(self.owner.player:GetPlayerID(), true)
  end
end




function sell(event)
  local unit = event.caster.unit
  local player = unit.player
  unit:RemoveNPC()
  local gold = unit.goldCost / 2
  if GameRules:GetGameTime() <= (unit.buytime + 6) then
    gold = unit.goldCost
  end
  PlayerResource:ModifyGold(player:GetPlayerID(), gold, true, DOTA_ModifyGold_Unspecified)
  table.remove(unit.player.units, unit.player:GetUnitKey(unit))
end



function leaveLane(trigger)
  local npc = trigger.activator
  if npc and not npc:IsRealHero() then
    if npc:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
      PopupSadface(npc)
      npc.leftLane = true
      if npc.lane.player then
        npc.lane.player:Leaked(self)
      end
      npc:SetMinimumGoldBounty(1)
      npc:SetMaximumGoldBounty(1)
      --npc.nextTarget = npc.lastWaypoint
    end
  end
end



function upgrade_unit(event)
  local id = event.ability:GetSpecialValueFor("unitID")
  local newclass = Game.GetUnitNameByID(id)
  event.caster.unit.npcclass = newclass
  event.caster.unit:Respawn()
  event.caster.unit.foodCost = event.caster.unit.foodCost
    + event.ability:GetSpecialValueFor("food_cost")
  event.caster.unit.goldCost = event.caster.unit.goldCost
    + event.ability:GetGoldCost(event.ability:GetLevel())
end



function OnStartTouch(trigger) -- trigger at end of lane to teleport to final defense
  local npc = trigger.activator
  if npc.unit and not npc:IsRealHero() then
    if not (npc:GetTeamNumber() == DOTA_TEAM_NEUTRALS) then
      npc.nextTarget = Game.lastDefends[""..npc:GetTeamNumber()]:GetAbsOrigin()
      FindClearSpaceForUnit(npc, npc.nextTarget, true)
      npc:Stop()
    end
  end
end