-- Generated from Data/Land's_End_District.xml
-- Unique district, adjacency/yield data and requirement-gated modifiers.
-- Do not add idempotent DELETE statements here: Civ VI XML <Row> semantics are INSERT-only.

-- Registers an identifier and its engine kind before domain rows use it.
INSERT INTO Types
    (Type, Kind)
VALUES
    ('DISTRICT_WHITE_HOLY_SITE', 'KIND_DISTRICT'),
    ('TRAIT_DISTRICT_WHITE_HOLY_SITE', 'KIND_TRAIT');

INSERT INTO Traits
    (TraitType, Name, Description)
VALUES
    ('TRAIT_DISTRICT_WHITE_HOLY_SITE', 'LOC_TRAIT_DISTRICT_WHITE_HOLY_SITE_NAME', 'LOC_TRAIT_DISTRICT_WHITE_HOLY_SITE_DESCRIPTION');

-- Maps the civilization-unique district to the base district it replaces.
INSERT INTO DistrictReplaces
    (CivUniqueDistrictType, ReplacesDistrictType)
VALUES
    ('DISTRICT_WHITE_HOLY_SITE', 'DISTRICT_HOLY_SITE');

INSERT INTO Districts
    (DistrictType, Name, Description, PrereqTech, PlunderType, PlunderAmount, AdvisorType, Cost, CostProgressionModel, CostProgressionParam1, Maintenance, RequiresPlacement, RequiresPopulation, AllowsHolyCity, Aqueduct, NoAdjacentCity, InternalOnly, ZOC, CaptureRemovesBuildings, CaptureRemovesCityDefenses, MilitaryDomain, Appeal, CityStrengthModifier, TraitType)
VALUES
    ('DISTRICT_WHITE_HOLY_SITE', 'LOC_DISTRICT_WHITE_HOLY_SITE_NAME', 'LOC_DISTRICT_WHITE_HOLY_SITE_DESCRIPTION', 'TECH_ASTROLOGY', 'PLUNDER_FAITH', 25, 'ADVISOR_RELIGIOUS', 27, 'COST_PROGRESSION_NUM_UNDER_AVG_PLUS_TECH', 40, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 'NO_DOMAIN', 1, 2, 'TRAIT_DISTRICT_WHITE_HOLY_SITE');

-- Bridge from a district to a reusable adjacency yield rule.
INSERT INTO District_Adjacencies
    (DistrictType, YieldChangeId)
VALUES
    ('DISTRICT_WHITE_HOLY_SITE', 'NaturalWonder_Faith'),
    ('DISTRICT_WHITE_HOLY_SITE', 'Mountain_Faith1'),
    ('DISTRICT_WHITE_HOLY_SITE', 'Mountain_Faith2'),
    ('DISTRICT_WHITE_HOLY_SITE', 'Mountain_Faith3'),
    ('DISTRICT_WHITE_HOLY_SITE', 'Mountain_Faith4'),
    ('DISTRICT_WHITE_HOLY_SITE', 'Mountain_Faith5'),
    ('DISTRICT_WHITE_HOLY_SITE', 'Forest_Faith'),
    ('DISTRICT_WHITE_HOLY_SITE', 'District_Faith');

INSERT INTO District_GreatPersonPoints
    (DistrictType, GreatPersonClassType, PointsPerTurn)
VALUES
    ('DISTRICT_WHITE_HOLY_SITE', 'GREAT_PERSON_CLASS_PROPHET', 2);

INSERT INTO District_TradeRouteYields
    (DistrictType, YieldType, YieldChangeAsOrigin, YieldChangeAsDomesticDestination, YieldChangeAsInternationalDestination)
VALUES
    ('DISTRICT_WHITE_HOLY_SITE', 'YIELD_FOOD', 0, 1, 0),
    ('DISTRICT_WHITE_HOLY_SITE', 'YIELD_FAITH', 0, 0, 1);

INSERT INTO District_CitizenYieldChanges
    (DistrictType, YieldType, YieldChange)
VALUES
    ('DISTRICT_WHITE_HOLY_SITE', 'YIELD_FAITH', 2);

INSERT INTO DistrictModifiers
    (DistrictType, ModifierId)
VALUES
    ('DISTRICT_WHITE_HOLY_SITE', 'MODIFIER_DISTRICT_WHITE_HOLY_SITE_UNIT_ADJUST_PROPERTY');

-- Defines an effect and optionally points to a RequirementSet.
INSERT INTO Modifiers
    (ModifierId, ModifierType)
VALUES
    ('MODIFIER_DISTRICT_WHITE_HOLY_SITE_UNIT_ADJUST_PROPERTY', 'MODIFIER_PLAYER_ADJUST_PROPERTY'),
    ('MODIFIER_LILY_UNITS_STRENGTH_ADJUST_FROM_PROPERTY', 'MODIFIER_PLAYER_UNITS_ADJUST_COMBAT_STRENGTH');

INSERT INTO Modifiers
    (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES
    ('MODIFIER_DISTRICT_WHITE_HOLY_SITE_PER_POPULATION_YIELD', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_PER_POPULATION', 'REQSET_LE_CITY_HAS_DISTRICT'),
    ('MODIFIER_LE_MINE_FOOD', 'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER', 'REQSET_LE_CITY_HAS_DISTRICT'),
    ('MODIFIER_LE_MINE_FOOD_MODIFIER', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'REQUIREMENTS_LE_HAS_MINE');

-- Key/value parameters consumed by each ModifierType.
INSERT INTO ModifierArguments
    (ModifierId, Name, Value)
VALUES
    ('MODIFIER_DISTRICT_WHITE_HOLY_SITE_UNIT_ADJUST_PROPERTY', 'Key', 'WHITE_HOLY_SITE_COMBAT_STRENGTH'),
    ('MODIFIER_DISTRICT_WHITE_HOLY_SITE_UNIT_ADJUST_PROPERTY', 'Amount', '1'),
    ('MODIFIER_LILY_UNITS_STRENGTH_ADJUST_FROM_PROPERTY', 'Key', 'WHITE_HOLY_SITE_COMBAT_STRENGTH'),
    ('MODIFIER_LILY_UNITS_STRENGTH_ADJUST_FROM_PROPERTY', 'Max', '10'),
    ('MODIFIER_DISTRICT_WHITE_HOLY_SITE_PER_POPULATION_YIELD', 'Amount', '0.5'),
    ('MODIFIER_DISTRICT_WHITE_HOLY_SITE_PER_POPULATION_YIELD', 'YieldType', 'YIELD_FAITH'),
    ('MODIFIER_LE_MINE_FOOD', 'ModifierId', 'MODIFIER_LE_MINE_FOOD_MODIFIER'),
    ('MODIFIER_LE_MINE_FOOD_MODIFIER', 'Amount', '1'),
    ('MODIFIER_LE_MINE_FOOD_MODIFIER', 'YieldType', 'YIELD_FOOD');

-- Defines how member requirements are evaluated (for example TEST_ALL).
INSERT INTO RequirementSets
    (RequirementSetId, RequirementSetType)
VALUES
    ('REQSET_LE_CITY_HAS_DISTRICT', 'REQUIREMENTSET_TEST_ALL'),
    ('REQUIREMENTS_LE_HAS_MINE', 'REQUIREMENTSET_TEST_ALL');

-- Bridge between RequirementSets and Requirements.
INSERT INTO RequirementSetRequirements
    (RequirementSetId, RequirementId)
VALUES
    ('REQSET_LE_CITY_HAS_DISTRICT', 'REQ_DISTRICT_WHITE_HOLY_SITE'),
    ('REQUIREMENTS_LE_HAS_MINE', 'REQ_LE_HAS_MINE');

-- Defines one reusable predicate.
INSERT INTO Requirements
    (RequirementId, RequirementType)
VALUES
    ('REQ_DISTRICT_WHITE_HOLY_SITE', 'REQUIREMENT_CITY_HAS_DISTRICT'),
    ('REQ_LE_HAS_MINE', 'REQUIREMENT_PLOT_IMPROVEMENT_TYPE_MATCHES');

-- Key/value parameters for each requirement predicate.
INSERT INTO RequirementArguments
    (RequirementId, Name, Value)
VALUES
    ('REQ_DISTRICT_WHITE_HOLY_SITE', 'DistrictType', 'DISTRICT_WHITE_HOLY_SITE'),
    ('REQ_LE_HAS_MINE', 'ImprovementType', 'IMPROVEMENT_MINE');

-- Bridge: a Trait owns one or more Modifiers.
INSERT INTO TraitModifiers
    (TraitType, ModifierId)
VALUES
    ('TRAIT_DISTRICT_WHITE_HOLY_SITE', 'MODIFIER_LILY_UNITS_STRENGTH_ADJUST_FROM_PROPERTY'),
    ('TRAIT_DISTRICT_WHITE_HOLY_SITE', 'MODIFIER_DISTRICT_WHITE_HOLY_SITE_PER_POPULATION_YIELD'),
    ('TRAIT_DISTRICT_WHITE_HOLY_SITE', 'MODIFIER_LE_MINE_FOOD');

INSERT INTO ModifierStrings
    (ModifierId, Context, Text)
VALUES
    ('MODIFIER_LILY_UNITS_STRENGTH_ADJUST_FROM_PROPERTY', 'Preview', 'LOC_MODIFIER_LILY_UNITS_STRENGTH_ADJUST_FROM_PROPERTY');
