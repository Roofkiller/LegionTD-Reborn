UnitTable = dofile("config_unit")

SpawnAbilities = {}

SpawnAbilities.tier1 = {
    "humanbuilder_spawn_militia",
    "naturebuilder_spawn_spider",
    "elementalbuilder_spawn_waterbender",
    "assassinbuilder_spawn_zealot_scarab",
    "undeadbuilder_spawn_zombie",
    "spiritbuilder_spawn_lost_spirit",
}

SpawnAbilities.tier2 = {
    "humanbuilder_spawn_archer",
    "naturebuilder_spawn_bug",
    "elementalbuilder_spawn_thunderbender",
    "assassinbuilder_spawn_mind_stealer",
    "undeadbuilder_spawn_mutilated_butcher",
    "spiritbuilder_spawn_vengeful_spirit",
}

SpawnAbilities.tier3 = {
    "humanbuilder_spawn_novice",
    "naturebuilder_spawn_bear",
    "elementalbuilder_spawn_earthbender",
    "assassinbuilder_spawn_creeping_shadow",
    "undeadbuilder_spawn_acolyte",
    "spiritbuilder_spawn_earth_spirit",
}

SpawnAbilities.tier4 = {
    "humanbuilder_spawn_gyrocopter_mk1",
    "naturebuilder_spawn_treant",
    "elementalbuilder_spawn_firebender",
    "assassinbuilder_spawn_lotus",
    "naturebuilder_spawn_hyena",
    "undeadbuilder_spawn_nether_drake",
    "spiritbuilder_spawn_storm_spirit",
}

SpawnAbilities.tier5 = {
    "humanbuilder_spawn_lieutenant",
    "elementalbuilder_spawn_voidbender",
    "naturebuilder_spawn_centaur",
    "assassinbuilder_spawn_jester",
    "undeadbuilder_spawn_vampire",
    "spiritbuilder_spawn_ember_spirit",
}

SpawnAbilities.tier6 = {
    "naturebuilder_spawn_centaur",
    "undeadbuilder_spawn_tormented_soul",
}

function GetRandomUnit(event)
    local tier = event.ability:GetSpecialValueFor("tier")
    local index = event.ability:GetAbilityIndex()
    event.unit:RemoveAbility(event.ability:GetName())
    local ind = math.random(#SpawnAbilities["tier" .. tier])
    local ability = event.unit:AddAbility(SpawnAbilities["tier" .. tier][ind])
    ability:SetAbilityIndex(index)
    ability.player = event.caster.player
    ability:SetLevel(1)
end
