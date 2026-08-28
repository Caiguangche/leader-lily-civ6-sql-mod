-- Developer-only validation queries. This file is intentionally NOT loaded by LeaderLily.civ6proj.
-- Run against Civilization VI's post-load Gameplay.sqlite (or FireTuner SQL) after the mod loads.

-- 1. Civilization -> Leader -> Trait ownership chain.
SELECT
    c.CivilizationType,
    cl.LeaderType,
    ct.TraitType AS CivilizationTrait,
    lt.TraitType AS LeaderTrait
FROM Civilizations AS c
JOIN CivilizationLeaders AS cl
    ON cl.CivilizationType = c.CivilizationType
LEFT JOIN CivilizationTraits AS ct
    ON ct.CivilizationType = c.CivilizationType
LEFT JOIN LeaderTraits AS lt
    ON lt.LeaderType = cl.LeaderType
WHERE c.CivilizationType = 'CIVILIZATION_LAND_S_END'
ORDER BY ct.TraitType, lt.TraitType;

-- 2. Trait -> Modifier -> RequirementSet -> Requirement, including arguments.
SELECT
    tm.TraitType,
    m.ModifierId,
    m.ModifierType,
    ma.Name AS ModifierArgument,
    ma.Value AS ModifierValue,
    rs.RequirementSetId,
    r.RequirementId,
    r.RequirementType,
    ra.Name AS RequirementArgument,
    ra.Value AS RequirementValue
FROM TraitModifiers AS tm
JOIN Modifiers AS m
    ON m.ModifierId = tm.ModifierId
LEFT JOIN ModifierArguments AS ma
    ON ma.ModifierId = m.ModifierId
LEFT JOIN RequirementSets AS rs
    ON rs.RequirementSetId = m.SubjectRequirementSetId
LEFT JOIN RequirementSetRequirements AS rsr
    ON rsr.RequirementSetId = rs.RequirementSetId
LEFT JOIN Requirements AS r
    ON r.RequirementId = rsr.RequirementId
LEFT JOIN RequirementArguments AS ra
    ON ra.RequirementId = r.RequirementId
WHERE tm.TraitType LIKE 'TRAIT_%LILY%'
   OR tm.TraitType LIKE 'TRAIT_%LAND_S_END%'
   OR tm.TraitType IN (
       'TRAIT_DISTRICT_WHITE_HOLY_SITE',
       'TRAIT_UNIT_UMBRAL_KNIGHT',
       'TRAIT_BUILDING_WHITE_PRUESTESS_STATUE'
   )
ORDER BY tm.TraitType, m.ModifierId, ma.Name, r.RequirementId;

-- 3. Unique-content replacement integrity.
SELECT 'District' AS ObjectKind, d.DistrictType AS UniqueType, dr.ReplacesDistrictType AS ReplacesType
FROM Districts AS d
JOIN DistrictReplaces AS dr ON dr.CivUniqueDistrictType = d.DistrictType
WHERE d.DistrictType = 'DISTRICT_WHITE_HOLY_SITE'
UNION ALL
SELECT 'Unit', u.UnitType, ur.ReplacesUnitType
FROM Units AS u
JOIN UnitReplaces AS ur ON ur.CivUniqueUnitType = u.UnitType
WHERE u.UnitType = 'UNIT_UMBRAL_KNIGHT'
UNION ALL
SELECT 'Building', b.BuildingType, br.ReplacesBuildingType
FROM Buildings AS b
JOIN BuildingReplaces AS br ON br.CivUniqueBuildingType = b.BuildingType
WHERE b.BuildingType = 'BUILDING_WHITE_PRUESTESS_STATUE';

-- Expected: zero rows. Any result is an orphaned modifier reference.
SELECT tm.TraitType, tm.ModifierId
FROM TraitModifiers AS tm
LEFT JOIN Modifiers AS m ON m.ModifierId = tm.ModifierId
WHERE m.ModifierId IS NULL
  AND (tm.TraitType LIKE '%LILY%' OR tm.TraitType LIKE '%LAND_S_END%');
