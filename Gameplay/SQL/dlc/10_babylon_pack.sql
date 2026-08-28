-- Generated from DLC/Land's_End_Babylon_Pack.xml
-- Babylon Pack compatibility: Mahavihara adjacency.
-- Do not add idempotent DELETE statements here: Civ VI XML <Row> semantics are INSERT-only.

-- Bridge from an improvement to a reusable adjacency yield rule.
INSERT INTO Improvement_Adjacencies
    (ImprovementType, YieldChangeId)
VALUES
    ('IMPROVEMENT_MAHAVIHARA', 'Mahavihara_White_Holy_Site_Faith');

INSERT INTO Adjacency_YieldChanges
    (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict)
VALUES
    ('Mahavihara_White_Holy_Site_Faith', 'Placeholder', 'YIELD_FAITH', 1, 1, 'DISTRICT_WHITE_HOLY_SITE');
