-- Generated from DLC/Land's_End_Expansion2.xml
-- Gathering Storm compatibility data and strategic resource cost.
-- Do not add idempotent DELETE statements here: Civ VI XML <Row> semantics are INSERT-only.

INSERT INTO MomentIllustrations
    (MomentIllustrationType, MomentDataType, GameDataType, Texture)
VALUES
    ('MOMENT_ILLUSTRATION_UNIQUE_DISTRICT', 'MOMENT_DATA_DISTRICT', 'DISTRICT_WHITE_HOLY_SITE', 'MOMENT_WHITE_HOLY_SITE'),
    ('MOMENT_ILLUSTRATION_UNIQUE_UNIT', 'MOMENT_DATA_UNIT', 'UNIT_UMBRAL_KNIGHT', 'MOMENT_UMBRAL_KNIGHT'),
    ('MOMENT_ILLUSTRATION_UNIQUE_BUILDING', 'MOMENT_DATA_BUILDING', 'BUILDING_WHITE_PRUESTESS_STATUE', 'MOMENT_BUILDING_WHITE_PRUESTESS_STATUE');

-- Bridge from a district to a reusable adjacency yield rule.
INSERT INTO District_Adjacencies
    (DistrictType, YieldChangeId)
VALUES
    ('DISTRICT_WHITE_HOLY_SITE', 'Government_Faith'),
    ('DISTRICT_SUGUBA', 'White_Holy_Site_Gold'),
    ('DISTRICT_WHITE_HOLY_SITE', 'Pamukkale_Faith');

INSERT INTO Adjacency_YieldChanges
    (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict)
VALUES
    ('White_Holy_Site_Gold', 'LOC_DISTRICT_HOLY_SITE_GOLD', 'YIELD_GOLD', 2, 1, 'DISTRICT_WHITE_HOLY_SITE');

INSERT INTO Units_XP2
    (UnitType, ResourceCost)
VALUES
    ('UNIT_UMBRAL_KNIGHT', 10);
