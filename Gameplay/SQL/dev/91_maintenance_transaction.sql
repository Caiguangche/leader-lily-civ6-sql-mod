-- Developer-only UPDATE/DELETE examples. This file is NOT loaded by the mod.
-- The transaction is rolled back, so it is safe for inspecting maintenance logic on a copied database.

BEGIN TRANSACTION;

-- Example balance edit scoped by the unit's primary key.
UPDATE Units
SET Cost = 100
WHERE UnitType = 'UNIT_UMBRAL_KNIGHT';

-- Example dependent-row cleanup before removing a trait-owned modifier link.
DELETE FROM TraitModifiers
WHERE TraitType = 'TRAIT_UNIT_UMBRAL_KNIGHT'
  AND ModifierId = 'MODIFIER_UNIT_UMBRAL_KNIGHT_IGNORE_TERRAIN_COST_ATTACH';

SELECT UnitType, Cost
FROM Units
WHERE UnitType = 'UNIT_UMBRAL_KNIGHT';

SELECT TraitType, ModifierId
FROM TraitModifiers
WHERE TraitType = 'TRAIT_UNIT_UMBRAL_KNIGHT';

ROLLBACK;
