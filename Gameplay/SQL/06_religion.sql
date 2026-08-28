-- Generated from Data/Land's_End_Religion.xml
-- Custom religion and pantheon belief modifier chain.
-- Do not add idempotent DELETE statements here: Civ VI XML <Row> semantics are INSERT-only.

-- Registers an identifier and its engine kind before domain rows use it.
INSERT INTO Types
    (Type, Kind)
VALUES
    ('BELIEF_PRIESTESS_WISH', 'KIND_BELIEF'),
    ('RELIGION_WHITE', 'KIND_RELIGION');

INSERT INTO Religions
    (ReligionType, Name, IconString, RequiresCustomName, Color)
VALUES
    ('RELIGION_WHITE', 'LOC_RELIGION_WHITE', 'Wh', 0, 'COLOR_RELIGION_WHITE');

INSERT INTO Beliefs
    (BeliefType, Name, Description, BeliefClassType)
VALUES
    ('BELIEF_PRIESTESS_WISH', 'LOC_BELIEF_PRIESTESS_WISH_NAME', 'LOC_BELIEF_PRIESTESS_WISH_DESCRIPTION', 'BELIEF_CLASS_PANTHEON');

INSERT INTO BeliefModifiers
    (BeliefType, ModifierId)
VALUES
    ('BELIEF_PRIESTESS_WISH', 'MODIFIER_BELIEF_PRIESTESS_WISH_UNITS_HEAL'),
    ('BELIEF_PRIESTESS_WISH', 'MODIFIER_BELIEF_PRIESTESS_WISH_CITY_LOYAL_ATTACH');

-- Defines an effect and optionally points to a RequirementSet.
INSERT INTO Modifiers
    (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES
    ('MODIFIER_BELIEF_PRIESTESS_WISH_UNITS_HEAL', 'MODIFIER_ALL_UNITS_ADJUST_HEAL_PER_TURN', 'PLAYER_HAS_PANTHEON_REQUIREMENTS'),
    ('MODIFIER_BELIEF_PRIESTESS_WISH_CITY_LOYAL_ATTACH', 'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', 'PLAYER_HAS_PANTHEON_REQUIREMENTS');

INSERT INTO Modifiers
    (ModifierId, ModifierType)
VALUES
    ('MODIFIER_BELIEF_PRIESTESS_WISH_CITY_LOYAL', 'MODIFIER_PLAYER_CITIES_ADJUST_ALWAYS_LOYAL');

-- Key/value parameters consumed by each ModifierType.
INSERT INTO ModifierArguments
    (ModifierId, Name, Value)
VALUES
    ('MODIFIER_BELIEF_PRIESTESS_WISH_UNITS_HEAL', 'Amount', '5'),
    ('MODIFIER_BELIEF_PRIESTESS_WISH_UNITS_HEAL', 'Type', 'ALL'),
    ('MODIFIER_BELIEF_PRIESTESS_WISH_CITY_LOYAL_ATTACH', 'ModifierId', 'MODIFIER_BELIEF_PRIESTESS_WISH_CITY_LOYAL'),
    ('MODIFIER_BELIEF_PRIESTESS_WISH_CITY_LOYAL', 'AlwaysLoyal', '1');
