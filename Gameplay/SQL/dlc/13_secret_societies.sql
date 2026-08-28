-- Generated from DLC/Land's_End_SecretSocieties.xml
-- Secret Societies mode compatibility: Ley Line adjacency.
-- Do not add idempotent DELETE statements here: Civ VI XML <Row> semantics are INSERT-only.

-- Bridge from a district to a reusable adjacency yield rule.
INSERT INTO District_Adjacencies
    (DistrictType, YieldChangeId)
VALUES
    ('DISTRICT_WHITE_HOLY_SITE', 'LeyLine_Faith');
