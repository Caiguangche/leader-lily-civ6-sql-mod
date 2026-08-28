#!/usr/bin/env python3
"""Validate that each migrated SQL module has the same row-level effect as XML.

The validator builds two isolated in-memory SQLite databases with an inferred
fixture schema, loads one from XML and one from SQL, then compares every table.
It catches missing rows, changed values, changed NULL/default behavior and SQL
syntax errors without requiring a local Civilization VI installation.
"""

from __future__ import annotations

from collections import OrderedDict
import sqlite3
from pathlib import Path
import sys
import xml.etree.ElementTree as ET

from migrate_xml_to_sql import MIGRATIONS, ROOT, row_dict


def normalized(value: str | None) -> str | None:
    if value is None:
        return None
    if value.lower() == "true":
        return "1"
    if value.lower() == "false":
        return "0"
    return value


def xml_tables(source: Path) -> OrderedDict[str, list[OrderedDict[str, str]]]:
    result: OrderedDict[str, list[OrderedDict[str, str]]] = OrderedDict()
    for table in ET.parse(source).getroot():
        rows = [row_dict(row) for row in table.findall("Row")]
        if rows:
            result[table.tag] = rows
    return result


def create_schema(db: sqlite3.Connection, tables: OrderedDict[str, list[OrderedDict[str, str]]]) -> None:
    for table, rows in tables.items():
        columns: list[str] = []
        for row in rows:
            for column in row:
                if column not in columns:
                    columns.append(column)
        definitions = ", ".join(f'"{column}" TEXT' for column in columns)
        db.execute(f'CREATE TABLE "{table}" ({definitions})')


def load_xml(db: sqlite3.Connection, tables: OrderedDict[str, list[OrderedDict[str, str]]]) -> None:
    for table, rows in tables.items():
        for row in rows:
            columns = list(row)
            quoted = ", ".join(f'"{column}"' for column in columns)
            placeholders = ", ".join("?" for _ in columns)
            values = [normalized(row[column]) for column in columns]
            db.execute(f'INSERT INTO "{table}" ({quoted}) VALUES ({placeholders})', values)


def snapshot(db: sqlite3.Connection, table: str) -> list[tuple]:
    rows = db.execute(f'SELECT * FROM "{table}"').fetchall()
    return sorted(tuple(None if value is None else str(value) for value in row) for row in rows)


def validate_one(xml_name: str, sql_name: str) -> tuple[int, int]:
    tables = xml_tables(ROOT / xml_name)
    xml_db = sqlite3.connect(":memory:")
    sql_db = sqlite3.connect(":memory:")
    create_schema(xml_db, tables)
    create_schema(sql_db, tables)
    load_xml(xml_db, tables)
    sql_db.executescript((ROOT / sql_name).read_text(encoding="utf-8"))
    for table in tables:
        expected = snapshot(xml_db, table)
        actual = snapshot(sql_db, table)
        if expected != actual:
            raise AssertionError(f"{xml_name}: table {table} differs\nXML={expected}\nSQL={actual}")
    return len(tables), sum(len(rows) for rows in tables.values())


def main() -> int:
    total_rows = 0
    for xml_name, sql_name in MIGRATIONS.items():
        try:
            table_count, row_count = validate_one(xml_name, sql_name)
            total_rows += row_count
            print(f"PASS  {xml_name:<44} {table_count:>2} tables  {row_count:>3} rows")
        except Exception as exc:
            print(f"FAIL  {xml_name}: {exc}", file=sys.stderr)
            return 1
    print(f"PASS  all {len(MIGRATIONS)} modules, {total_rows} source rows equivalent")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
