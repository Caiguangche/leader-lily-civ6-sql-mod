# Ender Lilies: Lily — Civilization VI SQLite Mod

这是一个将《Civilization VI》Gameplay 数据从 XML 迁移到模块化 SQL 的可运行 ModBuddy 工程。项目以 **Ender Lilies: Lily** 原 Mod 为基础，保留原有文明、领袖、特色区域、特色单位、特色建筑、宗教及 DLC 兼容逻辑，不改变数值与游戏设计。

本次重构的重点不是把 XML 标签机械换成 SQL，而是展示一个可审计、可验证、适合公开 GitHub 的 SQLite 数据项目：

- 10 个 XML Gameplay 模块拆分为 10 个职责明确的 SQL 文件；
- 257 条源数据完成逐行、逐列等价性验证；
- 使用 `INSERT` 表达与原 XML `<Row>` 完全一致的新增语义；
- 使用 `SELECT`、`JOIN` 检查核心关系和孤立引用；
- 提供事务化 `UPDATE` / `DELETE` 维护示例，但不接入游戏加载流程；
- XML 原件保留为审计基线，UI、图标、颜色、本地化、ArtDef 与资源文件继续使用原格式。

## Civilization VI 的 SQLite 数据层

Civilization VI Mod 并不是把所有内容写进同一张表。`LeaderLily.civ6proj` 通过不同 action 把文件送入不同用途的数据层：

| Action | 本项目用途 | 处理方式 |
| --- | --- | --- |
| `UpdateDatabase` | Civilization、Leader、Trait、Modifier、Requirement、District、Unit、Building、Religion | 已迁移为模块化 SQL |
| `UpdateIcons` | 图标图集与图标定义 | 保留 XML |
| `UpdateColors` | 玩家与宗教颜色 | 保留 XML |
| `UpdateText` | 简中、繁中、英文、日文本地化 | 保留 XML |
| `UpdateArt` | ArtDef、纹理、模型等美术资产 | 保留原格式 |
| `UpdateAudio` | Wwise 音频配置 | 保留原格式 |

XML `<Row>` 与 SQL `INSERT INTO ... VALUES ...` 都是在向 Gameplay SQLite 表插入记录。迁移版保留原加载顺序与 action criteria，因此 Rise and Fall、Gathering Storm、Babylon Pack、Secret Societies 的条件加载逻辑不变。

## 项目结构

```text
LeaderLily_SQL/
├── Gameplay/SQL/
│   ├── 01_civilization.sql
│   ├── 02_leader.sql
│   ├── 03_district.sql
│   ├── 04_unit.sql
│   ├── 05_building.sql
│   ├── 06_religion.sql
│   ├── dlc/                    # 按 DLC / 游戏模式条件加载
│   └── dev/                    # 仅用于查询和维护演示，不由 Mod 加载
├── Data/                       # 原 XML 基线 + Config/Icon/Color
├── DLC/                        # 原 DLC XML 基线
├── Text/                       # 本地化，保留 XML
├── ArtDefs/ Assets/ Textures/  # 美术资源，保持原样
├── docs/
│   ├── sql-schema.md
│   ├── migration-map.md
│   └── validation-report.md
├── tools/
│   ├── migrate_xml_to_sql.py
│   └── validate_equivalence.py
└── LeaderLily.civ6proj         # 已改为加载 Gameplay/SQL 下的运行时 SQL
```

## SQL 使用方式

### 在 ModBuddy 中构建

1. 使用 Civilization VI Development Tools / ModBuddy 打开 `LeaderLily.civ6proj`。
2. 正常 Build 项目。
3. `LE_Data` action 会依次加载 `01` 至 `06`；DLC SQL 仍由原有 criteria 决定是否加载。
4. `Gameplay/SQL/dev/` 不在项目 action 中，不会改变实际游戏数据。

公开源码仓库默认不提交 `.dds`、`.bnk`、`.wem` 等第三方媒体二进制，因此可直接运行 SQL 等价性测试，但不能仅依靠仓库内容构建完整美术/音频版本。完整构建时需从你拥有合法使用权的原 Mod 资源中恢复这些文件。

原压缩包也已移除部分 `.wem` 文件，而 `civ6proj` 仍保留历史引用；若 ModBuddy 报告音频缺失，请补回相应文件，或在确认不再需要音频后另行清理引用。这与 SQL 迁移无关，本次没有擅自改变音频设计。

### 重新生成 SQL

在项目根目录执行：

```bash
python tools/migrate_xml_to_sql.py
```

迁移映射是显式白名单，脚本不会处理 Config、Icon、Color、本地化或美术文件。

### 执行等价性测试

```bash
python tools/validate_equivalence.py
```

脚本为每个模块建立两份隔离的内存 SQLite 数据库：一份加载 XML，一份执行 SQL，然后比较所有表的完整结果集。当前预期结果：

```text
PASS  all 10 modules, 257 source rows equivalent
```

这项测试验证 XML→SQL 的数据等价和 SQL 语法；它不能替代游戏内加载测试。发布前仍应查看 Civilization VI 的 `Database.log` 与 `Modding.log`，并进行一局启动验证。

## 核心数据关系

最重要的两条链路是：

```text
Civilizations -> CivilizationLeaders -> Leaders
Civilizations/Leaders -> Traits -> TraitModifiers -> Modifiers
                                              -> RequirementSets
                                              -> Requirements
```

- `CivilizationTraits` 与 `LeaderTraits` 决定能力归属；
- `TraitModifiers` 把能力挂到具体效果；
- `ModifierArguments` 为效果提供参数；
- `SubjectRequirementSetId` 限制效果作用对象；
- `RequirementSetRequirements` 连接条件集与原子条件；
- `RequirementArguments` 提供建筑、区域、单位或改良设施类型等匹配参数。

完整说明见 [docs/sql-schema.md](docs/sql-schema.md)。

逐模块测试记录见 [docs/validation-report.md](docs/validation-report.md)。

## SQL 查询与维护示例

- `Gameplay/SQL/dev/90_validation_queries.sql`：多表 `SELECT/JOIN`，验证文明—领袖—能力链、Modifier/Requirement 链、特色内容替代关系和孤立引用。
- `Gameplay/SQL/dev/91_maintenance_transaction.sql`：带主键条件的 `UPDATE` 与依赖行 `DELETE` 示例，使用 `ROLLBACK` 保证不会持久修改测试数据库。

核心运行 SQL 没有加入 `DELETE` 或预清理语句，因为原 XML 使用的是 `<Row>`：其准确语义是 INSERT-only。为追求“可重复执行”而先删除同名数据，会改变冲突行为，不符合本项目的等价迁移目标。

## 迁移范围与文件对应

详见 [docs/migration-map.md](docs/migration-map.md)。概要如下：

| 原 XML | 新 SQL | 状态 |
| --- | --- | --- |
| Civilization | `01_civilization.sql` | 已迁移并验证 |
| Leader / Agenda | `02_leader.sql` | 已迁移并验证 |
| District | `03_district.sql` | 已迁移并验证 |
| Unit | `04_unit.sql` | 已迁移并验证 |
| Building | `05_building.sql` | 已迁移并验证 |
| Religion / Belief | `06_religion.sql` | 已迁移并验证 |
| 4 个 DLC 兼容文件 | `dlc/10`–`13` | 已迁移并验证 |

## 媒体资源与公开仓库边界

SQL、验证脚本、XML 数据、ArtDef/XLP 定义、本地化与文档适合作为数据库项目展示。Ender Lilies 相关图像、音频等第三方媒体二进制由 `.gitignore` 排除，不属于公开源码发布内容，也不受未来代码许可证覆盖。

`LICENSE` 中的 MIT 条款仅覆盖本次重构新增的 SQL、Python 工具和文档；不会对 Civilization VI、Ender Lilies、旧版 Mod 源文件或第三方资产授予任何权利。

## Technical highlights

- 将 10 个 XML Gameplay 模块迁移为按领域拆分的 SQL，覆盖 Civilization、Leader、Trait、Modifier、Requirement、District、Unit、Building 和 DLC 兼容关系；
- 设计 Python + SQLite 自动等价性测试，对 257 条源数据进行逐表、逐行、逐列校验；
- 使用多表 `JOIN` 展开能力归属与条件链，并检查特色内容替代关系和孤立引用；
- 区分 Gameplay、Configuration、Icons、Localization、Art 与 Audio 数据边界，保留不同 action 的正确加载方式。
