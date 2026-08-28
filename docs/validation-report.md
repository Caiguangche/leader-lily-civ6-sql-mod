# SQL Data Validation Report

Validation date: 2026-08-28  
Validator: `tools/validate_equivalence.py` (Python standard library + SQLite in-memory databases)

## Result

| Source module | Tables | Rows | Result |
| --- | ---: | ---: | --- |
| `Data/Land's_End_Civilization.xml` | 11 | 52 | PASS |
| `Data/Land's_End_Leader.xml` | 17 | 47 | PASS |
| `Data/Land's_End_District.xml` | 17 | 44 | PASS |
| `Data/Land's_End_Units.xml` | 14 | 21 | PASS |
| `Data/Land's_End_Building.xml` | 16 | 65 | PASS |
| `Data/Land's_End_Religion.xml` | 6 | 13 | PASS |
| `DLC/Land's_End_Babylon_Pack.xml` | 2 | 2 | PASS |
| `DLC/Land's_End_Expansion1.xml` | 2 | 4 | PASS |
| `DLC/Land's_End_Expansion2.xml` | 4 | 8 | PASS |
| `DLC/Land's_End_SecretSocieties.xml` | 1 | 1 | PASS |
| **Total** | **90 table occurrences** | **257** | **PASS** |

Additional project checks:

- `LeaderLily.civ6proj` is well-formed XML: PASS
- all 10 runtime SQL modules are referenced by `InGameActionData`: PASS
- developer validation/maintenance SQL is excluded from runtime actions: PASS
- original Config/Icon/Color/Text/Art/Audio actions remain unchanged: PASS

## Validation method

For each data module, the validator:

1. parses all XML `<Table><Row ... /></Table>` records, including child-element field syntax;
2. infers an isolated fixture schema for the module;
3. loads normalized XML values into one in-memory SQLite database;
4. executes the generated SQL in a second in-memory SQLite database;
5. compares the complete sorted row set of every table.

Rows with different XML attribute sets are emitted as separate `INSERT` statements. This preserves omitted-column/default semantics instead of incorrectly replacing an omitted field with explicit `NULL`.

## Scope and limitation

The test proves row-level XML/SQL equivalence and catches SQL syntax errors. It does not ship Firaxis's complete Gameplay schema and therefore does not replace a ModBuddy build plus in-game smoke test. The final release check should include `Database.log`, `Modding.log`, leader selection, game creation and one-turn verification under each supported ruleset.
