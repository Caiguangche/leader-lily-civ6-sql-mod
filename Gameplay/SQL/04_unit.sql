-- Generated from Data/Land's_End_Units.xml
-- Unique unit, replacement/upgrade data and unit-type requirement chain.
-- Do not add idempotent DELETE statements here: Civ VI XML <Row> semantics are INSERT-only.

-- Registers an identifier and its engine kind before domain rows use it.
INSERT INTO Types
    (Type, Kind)
VALUES
    ('UNIT_UMBRAL_KNIGHT', 'KIND_UNIT'),
    ('TRAIT_UNIT_UMBRAL_KNIGHT', 'KIND_TRAIT');

INSERT INTO Traits
    (TraitType, Name, Description)
VALUES
    ('TRAIT_UNIT_UMBRAL_KNIGHT', 'LOC_TRAIT_UNIT_UMBRAL_KNIGHT_NAME', 'LOC_TRAIT_UNIT_UMBRAL_KNIGHT_DESCRIPTION');

INSERT INTO UnitAiInfos
    (UnitType, AiType)
VALUES
    ('UNIT_UMBRAL_KNIGHT', 'UNITAI_COMBAT'),
    ('UNIT_UMBRAL_KNIGHT', 'UNITAI_EXPLORE'),
    ('UNIT_UMBRAL_KNIGHT', 'UNITTYPE_MELEE'),
    ('UNIT_UMBRAL_KNIGHT', 'UNITTYPE_LAND_COMBAT');

-- Maps the civilization-unique unit to the base unit it replaces.
INSERT INTO UnitReplaces
    (CivUniqueUnitType, ReplacesUnitType)
VALUES
    ('UNIT_UMBRAL_KNIGHT', 'UNIT_SWORDSMAN');

INSERT INTO TypeTags
    (Type, Tag)
VALUES
    ('UNIT_UMBRAL_KNIGHT', 'CLASS_MELEE');

INSERT INTO Units
    (UnitType, Cost, TraitType, Maintenance, BaseMoves, BaseSightRange, ZoneOfControl, Domain, Combat, StrategicResource, FormationClass, PromotionClass, AdvisorType, Name, Description, PurchaseYield, MandatoryObsoleteTech, PrereqTech)
VALUES
    ('UNIT_UMBRAL_KNIGHT', 90, 'TRAIT_UNIT_UMBRAL_KNIGHT', 2, 2, 2, 1, 'DOMAIN_LAND', 40, 'RESOURCE_IRON', 'FORMATION_CLASS_LAND_COMBAT', 'PROMOTION_CLASS_MELEE', 'ADVISOR_CONQUEST', 'LOC_UNIT_UMBRAL_KNIGHT_NAME', 'LOC_UNIT_UMBRAL_KNIGHT_DESCRIPTION', 'YIELD_GOLD', 'TECH_REPLACEABLE_PARTS', 'TECH_IRON_WORKING');

INSERT INTO UnitUpgrades
    (Unit, UpgradeUnit)
VALUES
    ('UNIT_UMBRAL_KNIGHT', 'UNIT_MAN_AT_ARMS');

-- Bridge: a Trait owns one or more Modifiers.
INSERT INTO TraitModifiers
    (TraitType, ModifierId)
VALUES
    ('TRAIT_UNIT_UMBRAL_KNIGHT', 'MODIFIER_UNIT_UMBRAL_KNIGHT_IGNORE_TERRAIN_COST_ATTACH');

-- Defines an effect and optionally points to a RequirementSet.
INSERT INTO Modifiers
    (ModifierId, ModifierType)
VALUES
    ('MODIFIER_UNIT_UMBRAL_KNIGHT_IGNORE_TERRAIN_COST', 'MODIFIER_PLAYER_UNIT_ADJUST_IGNORE_TERRAIN_COST');

INSERT INTO Modifiers
    (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES
    ('MODIFIER_UNIT_UMBRAL_KNIGHT_IGNORE_TERRAIN_COST_ATTACH', 'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER', 'REQSET_UNIT_UMBRAL_KNIGHT');

-- Key/value parameters consumed by each ModifierType.
INSERT INTO ModifierArguments
    (ModifierId, Name, Value)
VALUES
    ('MODIFIER_UNIT_UMBRAL_KNIGHT_IGNORE_TERRAIN_COST', 'Ignore', 1),
    ('MODIFIER_UNIT_UMBRAL_KNIGHT_IGNORE_TERRAIN_COST', 'Type', 'ALL'),
    ('MODIFIER_UNIT_UMBRAL_KNIGHT_IGNORE_TERRAIN_COST_ATTACH', 'ModifierId', 'MODIFIER_UNIT_UMBRAL_KNIGHT_IGNORE_TERRAIN_COST');

-- Defines how member requirements are evaluated (for example TEST_ALL).
INSERT INTO RequirementSets
    (RequirementSetId, RequirementSetType)
VALUES
    ('REQSET_UNIT_UMBRAL_KNIGHT', 'REQUIREMENTSET_TEST_ALL');

-- Bridge between RequirementSets and Requirements.
INSERT INTO RequirementSetRequirements
    (RequirementSetId, RequirementId)
VALUES
    ('REQSET_UNIT_UMBRAL_KNIGHT', 'REQ_UNIT_UMBRAL_KNIGHT');

-- Defines one reusable predicate.
INSERT INTO Requirements
    (RequirementId, RequirementType)
VALUES
    ('REQ_UNIT_UMBRAL_KNIGHT', 'REQUIREMENT_UNIT_TYPE_MATCHES');

-- Key/value parameters for each requirement predicate.
INSERT INTO RequirementArguments
    (RequirementId, Name, Value)
VALUES
    ('REQ_UNIT_UMBRAL_KNIGHT', 'UnitType', 'UNIT_UMBRAL_KNIGHT');
