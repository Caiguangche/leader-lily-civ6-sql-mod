-- Generated from DLC/Land's_End_Expansion1.xml
-- Rise and Fall compatibility data.
-- Do not add idempotent DELETE statements here: Civ VI XML <Row> semantics are INSERT-only.

-- Bridge from a district to a reusable adjacency yield rule.
INSERT INTO District_Adjacencies
    (DistrictType, YieldChangeId)
VALUES
    ('DISTRICT_WHITE_HOLY_SITE', 'Government_Faith');

INSERT INTO MomentIllustrations
    (MomentIllustrationType, MomentDataType, GameDataType, Texture)
VALUES
    ('MOMENT_ILLUSTRATION_UNIQUE_DISTRICT', 'MOMENT_DATA_DISTRICT', 'DISTRICT_WHITE_HOLY_SITE', 'MOMENT_WHITE_HOLY_SITE'),
    ('MOMENT_ILLUSTRATION_UNIQUE_UNIT', 'MOMENT_DATA_UNIT', 'UNIT_UMBRAL_KNIGHT', 'MOMENT_UMBRAL_KNIGHT'),
    ('MOMENT_ILLUSTRATION_UNIQUE_BUILDING', 'MOMENT_DATA_BUILDING', 'BUILDING_WHITE_PRUESTESS_STATUE', 'MOMENT_BUILDING_WHITE_PRUESTESS_STATUE');
