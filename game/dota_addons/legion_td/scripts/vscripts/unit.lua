if Unit == nil then
  Unit = class({})
end


ai_standard = require('ai/ai_core')
--Naturebuilder AI
ai_broodmother = require('ai/naturebuilder/ai_broodmother')
ai_bigcentaur = require('ai/naturebuilder/ai_bigcentaur')
--Elementalbuilder AI
ai_fireelemental = require('ai/elementalbuilder/ai_fireelemental')
ai_firegod = require('ai/elementalbuilder/ai_firegod')
ai_thunderelemental = require('ai/elementalbuilder/ai_thunderelemental')
ai_thundergod = require('ai/elementalbuilder/ai_thundergod')
ai_thunderwarrior = require('ai/elementalbuilder/ai_thunderwarrior')
ai_voidelemental = require('ai/elementalbuilder/ai_voidelemental')
ai_waterwarrior = require('ai/elementalbuilder/ai_waterwarrior')
--Humanbuilder AI
ai_militia = require('ai/humanbuilder/ai_militia')
ai_footman = require('ai/humanbuilder/ai_footman')
ai_soldier = require('ai/humanbuilder/ai_soldier')
ai_spearman = require('ai/humanbuilder/ai_spearman')


function Unit.GetUnitNameByID(id)
  if id == 1 then return "tower_naturebuilder_spider"
  elseif id == 2 then return "tower_naturebuilder_bug"
  elseif id == 3 then return "tower_naturebuilder_bear"
  elseif id == 4 then return "tower_naturebuilder_treant"
  elseif id == 5 then return "tower_naturebuilder_hyena"
  elseif id == 6 then return "tower_naturebuilder_centaur"
  elseif id == 7 then return "tower_naturebuilder_broodmother"
  elseif id == 8 then return "tower_naturebuilder_big_bug"
  elseif id == 9 then return "tower_naturebuilder_druid_bear"
  elseif id == 10 then return "tower_naturebuilder_iron_bear"
  elseif id == 11 then return "tower_naturebuilder_shroom"
  elseif id == 12 then return "tower_naturebuilder_flower_treant"
  elseif id == 13 then return "tower_naturebuilder_agressive_boar"
  elseif id == 14 then return "tower_naturebuilder_big_centaur"
  elseif id == 15 then return "tower_naturebuilder_centaur_warrunner"
  elseif id == 16 then return "tower_naturebuilder_treebeard"

  elseif id == 50 then return "tower_elementalbuilder_waterbender"
  elseif id == 51 then return "tower_elementalbuilder_thunderbender"
  elseif id == 52 then return "tower_elementalbuilder_earthbender"
  elseif id == 53 then return "tower_elementalbuilder_firebender"
  elseif id == 54 then return "tower_elementalbuilder_voidbender"
  elseif id == 55 then return "tower_elementalbuilder_waterelemental"
  elseif id == 56 then return "tower_elementalbuilder_waterwarrior"
  elseif id == 57 then return "tower_elementalbuilder_watergod"
  elseif id == 58 then return "tower_elementalbuilder_earthelemental"
  elseif id == 59 then return "tower_elementalbuilder_earthwarrior"
  elseif id == 60 then return "tower_elementalbuilder_earthgod"
  elseif id == 61 then return "tower_elementalbuilder_thunderelemental"
  elseif id == 62 then return "tower_elementalbuilder_thunderwarrior"
  elseif id == 63 then return "tower_elementalbuilder_thundergod"
  elseif id == 64 then return "tower_elementalbuilder_fireelemental"
  elseif id == 65 then return "tower_elementalbuilder_firewarrior"
  elseif id == 66 then return "tower_elementalbuilder_firegod"
  elseif id == 67 then return "tower_elementalbuilder_voidelemental"
  elseif id == 68 then return "tower_elementalbuilder_voidwarrior"
  elseif id == 69 then return "tower_elementalbuilder_voidgod"

  elseif id == 100 then return "tower_humanbuilder_archbishop"
  elseif id == 101 then return "tower_humanbuilder_archer"
  elseif id == 102 then return "tower_humanbuilder_archmage"
  elseif id == 103 then return "tower_humanbuilder_blademaster"
  elseif id == 104 then return "tower_humanbuilder_footman"
  elseif id == 105 then return "tower_humanbuilder_futuristic_gyrocopter"
  elseif id == 106 then return "tower_humanbuilder_general"
  elseif id == 107 then return "tower_humanbuilder_gunner"
  elseif id == 108 then return "tower_humanbuilder_gyrocopter_mk1"
  elseif id == 109 then return "tower_humanbuilder_gyrocopter_mk2"
  elseif id == 110 then return "tower_humanbuilder_hunter"
  elseif id == 111 then return "tower_humanbuilder_icewrack_grandmaster"
  elseif id == 112 then return "tower_humanbuilder_lieutenant"
  elseif id == 113 then return "tower_humanbuilder_mage"
  elseif id == 114 then return "tower_humanbuilder_marksman"
  elseif id == 115 then return "tower_humanbuilder_militia"
  elseif id == 116 then return "tower_humanbuilder_novice"
  elseif id == 117 then return "tower_humanbuilder_paladin"
  elseif id == 118 then return "tower_humanbuilder_sharpshooter"
  elseif id == 119 then return "tower_humanbuilder_soldier"
  elseif id == 120 then return "tower_humanbuilder_soundmaster"
  elseif id == 121 then return "tower_humanbuilder_spearman"
  elseif id == 122 then return "tower_humanbuilder_tactician"
  
      elseif id == 150 then return "tower_mechanicalbuilder_vacuum_cleaner"
      elseif id == 151 then return "tower_mechanicalbuilder_catapult"

  elseif id == 200 then return "tower_xbuilder_baseunit"
  elseif id == 201 then return "tower_xbuilder_offensiveunit"
  elseif id == 202 then return "tower_xbuilder_defensiveunit"
  elseif id == 203 then return "tower_xbuilder_utilityunit"
  elseif id == 204 then return "tower_xbuilder_abilityunit"

  elseif id == 1001 then return "incomeunit_kobold"
  elseif id == 1002 then return "incomeunit_hill_troll_shaman"
  elseif id == 1003 then return "incomeunit_hill_troll_warrior"
  elseif id == 1004 then return "incomeunit_harpy"
  elseif id == 1005 then return "incomeunit_ghost"
  elseif id == 1006 then return "incomeunit_little_wolf"
  elseif id == 1007 then return "incomeunit_satyr"
  elseif id == 1008 then return "incomeunit_ogre_warrior"
  elseif id == 1009 then return "incomeunit_little_centaur"
  elseif id == 1010 then return "incomeunit_wolf"
  elseif id == 1011 then return "incomeunit_golem"
  elseif id == 1012 then return "incomeunit_little_golem"
  elseif id == 1013 then return "incomeunit_centaur"
  elseif id == 1014 then return "incomeunit_vulture"
  elseif id == 1015 then return "incomeunit_lizard"
  elseif id == 1016 then return "incomeunit_lycanwolf"
  elseif id == 1017 then return "incomeunit_black_drake"
  elseif id == 1018 then return "incomeunit_big_lizard"
  elseif id == 1019 then return "incomeunit_ancientgolem"
  elseif id == 1020 then return "incomeunit_fleshgolem"
  elseif id == 1021 then return "incomeunit_jellyfish"
  elseif id == 1022 then return "incomeunit_hulk"
  elseif id == 1023 then return "incomeunit_beast"
  elseif id == 1024 then return "incomeunit_diablo"
  elseif id == 1025 then return "incomeunit_rosh"
    -- elseif id == 16 then return "tower_naturebuilder_centaur"
  end
end


function Unit.new(npcclass, position, owner, foodCost, goldCost)
  local self = Unit()
  self.owner = owner
  self.player = owner.player
  self.buyround = Game:GetCurrentRound()
  self.goldCost = goldCost
  self.foodCost = foodCost
  self.npcclass = npcclass
  self.spawnposition = position
  self.target = self.player.lane.unitWaypoint
  self.nextTarget = self.target:GetAbsOrigin()
  self.nextTarget.x = self.spawnposition.x
  table.insert(self.player.units, self)
  self:Spawn()
  return self
end



function Unit:Spawn()
  --PrecacheUnitByNameAsync(self.npcclass, function ()
    self.npc = CreateUnitByName(self.npcclass, self.spawnposition, false, nil,
    self.owner, self.owner:GetTeamNumber())
    if self.spawnposition.y > 0 then
      self.npc:SetAngles(0, 90, 0)
    else
      self.npc:SetAngles(0, 270, 0)
    end
    self.npc.unit = self
    self.npc.player = self.player
    self.npc.nextTarget = self.nextTarget
    self.npc:SetMinimumGoldBounty(self.foodCost)
    self.npc:SetMaximumGoldBounty(self.foodCost)
    self:Lock()
  --end
  --)
end



function Unit:ApplyAI()
  local name = self:GetUnitName()
  if name == "tower_naturebuilder_broodmother" then ai_broodmother.Init(self)
  elseif name == "tower_naturebuilder_big_centaur" then ai_bigcentaur.Init(self)
  elseif name == "tower_elementalbuilder_earthgod" then return
  elseif name == "tower_elementalbuilder_fireelemental" then ai_fireelemental.Init(self)
  elseif name == "tower_elementalbuilder_firegod" then ai_firegod.Init(self)
  elseif name == "tower_elementalbuilder_firewarrior" then return
  elseif name == "tower_elementalbuilder_thunderelemental" then ai_thunderelemental.Init(self)
  elseif name == "tower_elementalbuilder_thundergod" then ai_thundergod.Init(self)
  elseif name == "tower_elementalbuilder_thunderwarrior" then ai_thunderwarrior.Init(self)
  elseif name == "tower_elementalbuilder_voidelemental" then ai_voidelemental.Init(self)
  elseif name == "tower_elementalbuilder_voidgod" then return
  elseif name == "tower_elementalbuilder_watergod" then return
  elseif name == "tower_elementalbuilder_waterwarrior" then ai_waterwarrior.Init(self)
  elseif name == "tower_humanbuilder_footman" then ai_footman.Init(self)
  elseif name == "tower_humanbuilder_soldier" then ai_soldier.Init(self)
  elseif name == "tower_humanbuilder_spearman" then ai_spearman.Init(self)
  elseif name == "tower_humanbuilder_paladin" then return
  elseif name == "tower_humanbuilder_blademaster" then return
  elseif name == "tower_humanbuilder_tactician" then return
  elseif name == "tower_humanbuilder_novice" then return
  elseif name == "tower_humanbuilder_mage" then return
  elseif name == "tower_humanbuilder_archmage" then return
  elseif name == "tower_humanbuilder_archbishop" then return
  elseif name == "tower_humanbuilder_soundmaster" then return
  elseif name == "tower_humanbuilder_gyrocopter_mk1" then return
  elseif name == "tower_humanbuilder_gyrocopter_mk2" then return
  elseif name == "tower_humanbuilder_futuristic_gyrocopter" then return
  elseif name == "tower_naturebuilder_treebeard" then return
  else ai_standard.Init(self)
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
    self.npc.nextTarget = self.nextTarget
    self:Unlock()
  end
end



function Unit:Unlock()
  if self.npc and not self.npc:IsNull() and self.npc:IsAlive() then
    self.npc:RemoveModifierByName("modifier_stunned")
    self.npc:RemoveModifierByName("modifier_invulnerable")
    self.npc:SetControllableByPlayer(-1, false)
    self.npc:Stop()
    self:EndCooldowns()
    Timers:CreateTimer(0.5, function ()
      local pos = self.npc.nextTarget
      --pos.x = self.spawnposition.x
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

function Unit:EndCooldowns()
  for i = 0, 16, 1 do
    local ability = self.npc:GetAbilityByIndex(i);
    if (ability and not ability:IsNull()) then
      ability:EndCooldown()
    end
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
  Timers:CreateTimer(1, function ()
      UTIL_RemoveImmediate(unit.npc)
    end)
  local gold = unit.goldCost / 2
  if unit.buyround == Game:GetCurrentRound() then
    gold = unit.goldCost
  end
  PlayerResource:ModifyGold(player:GetPlayerID(), gold, true, DOTA_ModifyGold_Unspecified)
  table.remove(unit.player.units, unit.player:GetUnitKey(unit))
  player:RefreshPlayerInfo()
end


function UnitSpawn(event)
  if not Game:IsBetweenRounds() then
    print ("player trying to build unit post-spawn!")
    playerid = event.unit:GetPlayerOwnerID()
    player = Game:FindPlayerWithID(playerid)
    player:SendErrorCode(LEGION_ERROR_BETWEEN_ROUNDS)
    return
  end
  local unit = Unit.new(Unit.GetUnitNameByID(event.ability:GetSpecialValueFor("unitID")),
    event.unit:GetCursorPosition(), event.caster, event.ability:GetSpecialValueFor("food_cost"),
    event.ability:GetGoldCost(event.ability:GetLevel()))
  event.caster.player:RefreshPlayerInfo()
end


function UpgradeUnit(event)
  local id = event.ability:GetSpecialValueFor("unitID")
  playerid = event.unit:GetPlayerOwnerID()
  local newclass = Unit.GetUnitNameByID(id)
  event.caster.unit.npcclass = newclass
  event.caster.unit:Respawn()
  event.caster.unit.foodCost = event.caster.unit.foodCost
    + event.ability:GetSpecialValueFor("food_cost")
  event.caster.unit.goldCost = event.caster.unit.goldCost
    + event.ability:GetGoldCost(event.ability:GetLevel())
  PlayerResource:NewSelection(playerid, event.caster.unit.npc)
end


function OnEndReached(trigger) -- trigger at end of lane to teleport to final defense
  local npc = trigger.activator
  if npc.unit and not npc:IsRealHero() then
    if not (npc:GetTeamNumber() == DOTA_TEAM_NEUTRALS) then
      npc.nextTarget = Game.lastDefends[""..npc:GetTeamNumber()]:GetAbsOrigin()
      if npc:GetAttackCapability() == DOTA_UNIT_CAP_RANGED_ATTACK then
        FindClearSpaceForUnit(npc, Game.lastDefendsRanged[""..npc:GetTeamNumber()]:GetAbsOrigin(), true)
        npc.nextTarget.y = npc.nextTarget.y - 200
      else
        FindClearSpaceForUnit(npc, npc.nextTarget, true)
      end
      ExecuteOrderFromTable({
            UnitIndex = npc:entindex(),
            OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
            TargetIndex = 0, --Optional.  Only used when targeting units
            AbilityIndex = 0, --Optional.  Only used when casting abilities
            Position = npc.nextTarget, --Optional.  Only used when targeting the ground
            Queue = 0 --Optional.  Used for queueing up abilities
          })
    end
  end
end
