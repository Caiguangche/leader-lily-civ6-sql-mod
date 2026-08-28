#!/usr/bin/env python3
"""Convert selected Civilization VI GameData XML files to modular SQL.

This is intentionally scoped: UI, localization, icon, color, ArtDef and asset
files are not candidates for conversion.  The mapping below is the migration
contract and is also consumed by validate_equivalence.py.
"""

from __future__ import annotations

from collections import OrderedDict
from pathlib import Path
import xml.etree.ElementTree as ET


ROOT = Path(__file__).resolve().parents[1]

MIGRATIONS = OrderedDict(
    [
        ("Data/Land's_End_Civilization.xml", "Gameplay/SQL/01_civilization.sql"),
        ("Data/Land's_End_Leader.xml", "Gameplay/SQL/02_leader.sql"),
        ("Data/Land's_End_District.xml", "Gameplay/SQL/03_district.sql"),
        ("Data/Land's_End_Units.xml", "Gameplay/SQL/04_unit.sql"),
        ("Data/Land's_End_Building.xml", "Gameplay/SQL/05_building.sql"),
        ("Data/Land's_End_Religion.xml", "Gameplay/SQL/06_religion.sql"),
        ("DLC/Land's_End_Babylon_Pack.xml", "Gameplay/SQL/dlc/10_babylon_pack.sql"),
        ("DLC/Land's_End_Expansion1.xml", "Gameplay/SQL/dlc/11_expansion1.sql"),
        ("DLC/Land's_End_Expansion2.xml", "Gameplay/SQL/dlc/12_expansion2.sql"),
        ("DLC/Land's_End_SecretSocieties.xml", "Gameplay/SQL/dlc/13_secret_societies.sql"),
    ]
)

MODULE_NOTES = {
    "01_civilization.sql": "Civilization identity, city/citizen names, trait ownership and civilization modifiers.",
    "02_leader.sql": "Leader identity, agenda/AI data, leader traits and their modifiers.",
    "03_district.sql": "Unique district, adjacency/yield data and requirement-gated modifiers.",
    "04_unit.sql": "Unique unit, replacement/upgrade data and unit-type requirement chain.",
    "05_building.sql": "Unique building, yields/prerequisites and city/district requirement chains.",
    "06_religion.sql": "Custom religion and pantheon belief modifier chain.",
    "10_babylon_pack.sql": "Babylon Pack compatibility: Mahavihara adjacency.",
    "11_expansion1.sql": "Rise and Fall compatibility data.",
    "12_expansion2.sql": "Gathering Storm compatibility data and strategic resource cost.",
    "13_secret_societies.sql": "Secret Societies mode compatibility: Ley Line adjacency.",
}

TABLE_NOTES = {
    "Types": "Registers an identifier and its engine kind before domain rows use it.",
    "CivilizationLeaders": "Many-to-many bridge between Civilizations and Leaders.",
    "CivilizationTraits": "Attaches civilization, district and building traits to the civilization.",
    "LeaderTraits": "Attaches leader and unique-unit traits to the leader.",
    "TraitModifiers": "Bridge: a Trait owns one or more Modifiers.",
    "Modifiers": "Defines an effect and optionally points to a RequirementSet.",
    "ModifierArguments": "Key/value parameters consumed by each ModifierType.",
    "RequirementSets": "Defines how member requirements are evaluated (for example TEST_ALL).",
    "RequirementSetRequirements": "Bridge between RequirementSets and Requirements.",
    "Requirements": "Defines one reusable predicate.",
    "RequirementArguments": "Key/value parameters for each requirement predicate.",
    "DistrictReplaces": "Maps the civilization-unique district to the base district it replaces.",
    "UnitReplaces": "Maps the civilization-unique unit to the base unit it replaces.",
    "BuildingReplaces": "Maps the civilization-unique building to the base building it replaces.",
    "District_Adjacencies": "Bridge from a district to a reusable adjacency yield rule.",
    "Improvement_Adjacencies": "Bridge from an improvement to a reusable adjacency yield rule.",
}

NUMERIC_COLUMNS = {
    "RandomCityNameDepth", "Female", "Tier", "SceneLayers", "PlayDawnOfManAudio",
    "Favored", "Permanent", "RunOnce", "Cost", "Maintenance", "CitizenSlots",
    "YieldChange", "PointsPerTurn", "NumSlots", "BaseMoves", "BaseSightRange",
    "ZoneOfControl", "Combat", "PlunderAmount", "CostProgressionParam1",
    "RequiresPlacement", "RequiresPopulation", "AllowsHolyCity", "Aqueduct",
    "NoAdjacentCity", "InternalOnly", "ZOC", "CaptureRemovesBuildings",
    "CaptureRemovesCityDefenses", "Appeal", "CityStrengthModifier",
    "YieldChangeAsOrigin", "YieldChangeAsDomesticDestination",
    "YieldChangeAsInternationalDestination", "ResourceCost", "TilesRequired",
}


def row_dict(row: ET.Element) -> OrderedDict[str, str]:
    values: OrderedDict[str, str] = OrderedDict(row.attrib)
    for child in row:
        values[child.tag] = child.text or ""
    return values


def sql_value(column: str, value: str) -> str:
    lowered = value.lower()
    if lowered == "true":
        return "1"
    if lowered == "false":
        return "0"
    if column in NUMERIC_COLUMNS:
        try:
            float(value)
            return value
        except ValueError:
            pass
    return "'" + value.replace("'", "''") + "'"


def render(source: Path, target: Path) -> str:
    root = ET.parse(source).getroot()
    lines = [
        "-- Generated from " + source.relative_to(ROOT).as_posix(),
        "-- " + MODULE_NOTES[target.name],
        "-- Do not add idempotent DELETE statements here: Civ VI XML <Row> semantics are INSERT-only.",
        "",
    ]
    for table in root:
        rows = [row_dict(row) for row in table.findall("Row")]
        if not rows:
            continue
        note = TABLE_NOTES.get(table.tag)
        if note:
            lines.append("-- " + note)
        # Rows with different column sets must use separate INSERT statements.
        # Supplying NULL for an omitted XML attribute is not equivalent: XML
        # omission asks the real Civ VI schema to apply that column's DEFAULT.
        groups: OrderedDict[tuple[str, ...], list[OrderedDict[str, str]]] = OrderedDict()
        for row in rows:
            groups.setdefault(tuple(row), []).append(row)
        for signature, group in groups.items():
            columns = list(signature)
            lines.append(f"INSERT INTO {table.tag}")
            lines.append("    (" + ", ".join(columns) + ")")
            lines.append("VALUES")
            rendered_rows = []
            for row in group:
                rendered = [sql_value(column, row[column]) for column in columns]
                rendered_rows.append("    (" + ", ".join(rendered) + ")")
            lines.append(",\n".join(rendered_rows) + ";")
            lines.append("")
    return "\n".join(lines).rstrip() + "\n"


def main() -> None:
    for xml_name, sql_name in MIGRATIONS.items():
        source = ROOT / xml_name
        target = ROOT / sql_name
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(render(source, target), encoding="utf-8")
        print(f"{xml_name} -> {sql_name}")


if __name__ == "__main__":
    main()
