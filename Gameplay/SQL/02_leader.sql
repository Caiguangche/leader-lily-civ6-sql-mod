-- Generated from Data/Land's_End_Leader.xml
-- Leader identity, agenda/AI data, leader traits and their modifiers.
-- Do not add idempotent DELETE statements here: Civ VI XML <Row> semantics are INSERT-only.

-- Registers an identifier and its engine kind before domain rows use it.
INSERT INTO Types
    (Type, Kind)
VALUES
    ('LEADER_LILY', 'KIND_LEADER'),
    ('TRAIT_AGENDA_LILY', 'KIND_TRAIT'),
    ('TRAIT_LEADER_LILY', 'KIND_TRAIT');

INSERT INTO Leaders
    (LeaderType, Name, InheritFrom, Sex, SceneLayers)
VALUES
    ('LEADER_LILY', 'LOC_LEADER_LILY_NAME', 'LEADER_DEFAULT', 'Female', 4);

INSERT INTO LeaderQuotes
    (LeaderType, Quote)
VALUES
    ('LEADER_LILY', 'LOC_LEADER_LILY_QUOTE');

INSERT INTO Traits
    (TraitType, Name, Description)
VALUES
    ('TRAIT_AGENDA_LILY', 'LOC_TRAIT_AGENDA_LILY_NAME', 'LOC_TRAIT_AGENDA_LILY_DESCRIPTION'),
    ('TRAIT_LEADER_LILY', 'LOC_TRAIT_LEADER_LILY_NAME', 'LOC_TRAIT_LEADER_LILY_DESCRIPTION');

-- Attaches leader and unique-unit traits to the leader.
INSERT INTO LeaderTraits
    (LeaderType, TraitType)
VALUES
    ('LEADER_LILY', 'TRAIT_LEADER_LILY'),
    ('LEADER_LILY', 'TRAIT_UNIT_UMBRAL_KNIGHT');

INSERT INTO AiListTypes
    (ListType)
VALUES
    ('LilyDiplomacy');

INSERT INTO AiLists
    (ListType, AgendaType, System)
VALUES
    ('LilyDiplomacy', 'TRAIT_AGENDA_LILY', 'DiplomaticActions');

INSERT INTO AiFavoredItems
    (ListType, Item, Favored)
VALUES
    ('LilyDiplomacy', 'DIPLOACTION_DECLARE_SURPRISE_WAR', 0),
    ('LilyDiplomacy', 'DIPLOACTION_DECLARE_FRIENDSHIP', 1);

INSERT INTO FavoredReligions
    (LeaderType, ReligionType)
VALUES
    ('LEADER_LILY', 'RELIGION_WHITE');

INSERT INTO Agendas
    (AgendaType, Name, Description)
VALUES
    ('AGENDA_LILY', 'LOC_AGENDA_LILY_NAME', 'LOC_AGENDA_LILY_DESCRIPTION');

INSERT INTO HistoricalAgendas
    (LeaderType, AgendaType)
VALUES
    ('LEADER_LILY', 'AGENDA_LILY');

INSERT INTO AgendaTraits
    (AgendaType, TraitType)
VALUES
    ('AGENDA_LILY', 'TRAIT_AGENDA_LILY');

INSERT INTO LoadingInfo
    (LeaderType, ForegroundImage, BackgroundImage, PlayDawnOfManAudio, EraText, LeaderText)
VALUES
    ('LEADER_LILY', 'LEADER_LILY_LOADING_FOREGROUND', 'LEADER_LILY_LOADING_BACKGROUND', 0, '', 'LOC_LOADING_INFO_LEADER_LILY');

-- Bridge: a Trait owns one or more Modifiers.
INSERT INTO TraitModifiers
    (TraitType, ModifierId)
VALUES
    ('TRAIT_LEADER_LILY', 'MODIFIER_LILY_UNITS_CAPTURE_UNIT_ATTACH'),
    ('TRAIT_LEADER_LILY', 'MODIFIER_LILY_UNITS_HEAL'),
    ('TRAIT_LEADER_LILY', 'MODIFIER_MODIFIER_LILY_UNITS_HEAL_AFTER_ACTION'),
    ('TRAIT_AGENDA_LILY', 'AGENDA_LILY_FRIEND'),
    ('TRAIT_AGENDA_LILY', 'AGENDA_LILY_DENOUNCED_FRIEND');

-- Defines an effect and optionally points to a RequirementSet.
INSERT INTO Modifiers
    (ModifierId, ModifierType)
VALUES
    ('MODIFIER_LILY_UNITS_CAPTURE_UNIT_ATTACH', 'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER'),
    ('MODIFIER_LILY_UNITS_CAPTURE_UNIT', 'MODIFIER_UNIT_ADJUST_COMBAT_UNIT_CAPTURE'),
    ('MODIFIER_LILY_UNITS_HEAL', 'MODIFIER_PLAYER_UNITS_ADJUST_HEAL_PER_TURN'),
    ('MODIFIER_MODIFIER_LILY_UNITS_HEAL_AFTER_ACTION', 'MODIFIER_PLAYER_UNITS_GRANT_HEAL_AFTER_ACTION');

INSERT INTO Modifiers
    (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES
    ('AGENDA_LILY_FRIEND', 'MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER', 'PLAYER_DECLARED_FRIEND'),
    ('AGENDA_LILY_DENOUNCED_FRIEND', 'MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER', 'PLAYER_FRIEND_DENOUNCED');

-- Key/value parameters consumed by each ModifierType.
INSERT INTO ModifierArguments
    (ModifierId, Name, Value)
VALUES
    ('MODIFIER_LILY_UNITS_CAPTURE_UNIT_ATTACH', 'ModifierId', 'MODIFIER_LILY_UNITS_CAPTURE_UNIT'),
    ('MODIFIER_LILY_UNITS_CAPTURE_UNIT', 'CanCapture', 1),
    ('MODIFIER_LILY_UNITS_HEAL', 'Amount', '5'),
    ('MODIFIER_LILY_UNITS_HEAL', 'Type', 'ALL'),
    ('AGENDA_LILY_FRIEND', 'InitialValue', '20'),
    ('AGENDA_LILY_FRIEND', 'ReductionTurns', '10'),
    ('AGENDA_LILY_FRIEND', 'ReductionValue', '1'),
    ('AGENDA_LILY_FRIEND', 'MessageThrottle', '20'),
    ('AGENDA_LILY_FRIEND', 'StatementKey', 'LOC_DIPLO_KUDO_LEADER_LILY_REASON_ANY'),
    ('AGENDA_LILY_FRIEND', 'SimpleModifierDescription', 'LOC_DIPLO_MODIFIER_LILY_DECLARED_FRIEND'),
    ('AGENDA_LILY_DENOUNCED_FRIEND', 'InitialValue', '-12'),
    ('AGENDA_LILY_DENOUNCED_FRIEND', 'ReductionTurns', '10'),
    ('AGENDA_LILY_DENOUNCED_FRIEND', 'ReductionValue', '-1'),
    ('AGENDA_LILY_DENOUNCED_FRIEND', 'MessageThrottle', '20'),
    ('AGENDA_LILY_DENOUNCED_FRIEND', 'StatementKey', 'LOC_DIPLO_WARNING_LEADER_LILY_REASON_ANY'),
    ('AGENDA_LILY_DENOUNCED_FRIEND', 'SimpleModifierDescription', 'LOC_DIPLO_MODIFIER_LILY_DENOUNCED_FRIEND');

INSERT INTO ModifierStrings
    (ModifierId, Context, Text)
VALUES
    ('AGENDA_LILY_FRIEND', 'Sample', 'LOC_TOOLTIP_SAMPLE_DIPLOMACY_ALL'),
    ('AGENDA_LILY_DENOUNCED_FRIEND', 'Sample', 'LOC_TOOLTIP_SAMPLE_DIPLOMACY_ALL');
