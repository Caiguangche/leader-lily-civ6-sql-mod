# Runtime SQL Module Map

本文记录 Gameplay 数据模块、验证输入与 ModBuddy action 之间的对应关系。`LeaderLily.civ6proj` 的运行时 `UpdateDatabase` action 加载 `Gameplay/SQL/`；XML 数据用于自动化结果对照，不作为 Gameplay 运行时输入。

## 核心模块

| 顺序 | 数据域 | 验证输入 | 运行时 SQL | 表数 | 记录数 | 验证 |
| ---: | --- | --- | --- | ---: | ---: | --- |
| 01 | Civilization | `Data/Land's_End_Civilization.xml` | `Gameplay/SQL/01_civilization.sql` | 11 | 52 | PASS |
| 02 | Leader / Agenda | `Data/Land's_End_Leader.xml` | `Gameplay/SQL/02_leader.sql` | 17 | 47 | PASS |
| 03 | District | `Data/Land's_End_District.xml` | `Gameplay/SQL/03_district.sql` | 17 | 44 | PASS |
| 04 | Unit | `Data/Land's_End_Units.xml` | `Gameplay/SQL/04_unit.sql` | 14 | 21 | PASS |
| 05 | Building | `Data/Land's_End_Building.xml` | `Gameplay/SQL/05_building.sql` | 16 | 65 | PASS |
| 06 | Religion / Belief | `Data/Land's_End_Religion.xml` | `Gameplay/SQL/06_religion.sql` | 6 | 13 | PASS |
| 10 | Babylon Pack | `DLC/Land's_End_Babylon_Pack.xml` | `Gameplay/SQL/dlc/10_babylon_pack.sql` | 2 | 2 | PASS |
| 11 | Rise and Fall | `DLC/Land's_End_Expansion1.xml` | `Gameplay/SQL/dlc/11_expansion1.sql` | 2 | 4 | PASS |
| 12 | Gathering Storm | `DLC/Land's_End_Expansion2.xml` | `Gameplay/SQL/dlc/12_expansion2.sql` | 4 | 8 | PASS |
| 13 | Secret Societies | `DLC/Land's_End_SecretSocieties.xml` | `Gameplay/SQL/dlc/13_secret_societies.sql` | 1 | 1 | PASS |
| | **合计** | | **10 个运行时模块** | **90 次模块内表使用** | **257** | **PASS** |

## 非 Gameplay 数据

Civilization VI 将配置、图标、颜色、本地化和美术数据交给不同 action 处理。这些文件保留其原生格式：

| 文件 / 目录 | Action / 用途 |
| --- | --- |
| `Data/Land's_End_Config.xml` | Front-end `UpdateDatabase`：`Players`、`PlayerItems` |
| `Data/Land's_End_Icon.xml` | `UpdateIcons`：图集与图标定义 |
| `Data/Land's_End_Color.xml` | `UpdateColors`：文明、领袖和宗教颜色 |
| `Text/*.xml` | `UpdateText`：四种语言的本地化文本 |
| `ArtDefs/*.artdef` | Civilization VI 美术对象定义 |
| `LeaderLily.Art.xml` | Mod Art Dependency 配置 |
| `Textures/`、`Assets/`、`XLPs/` | 纹理元数据、模型资产与资源包定义 |
| `Platforms/Windows/Audio/` | Wwise 音频运行资源；不包含在公开源码分发中 |

## Action 加载顺序

核心 Gameplay action 按 `01` 至 `06` 执行。DLC 模块使用独立 criteria：

| Action | Criteria | SQL |
| --- | --- | --- |
| `LE_Data` | 始终加载 | `01`–`06` |
| `LE_Babylon_Pack` | `LE_Babylon` | `dlc/10_babylon_pack.sql` |
| `LE_Expansion1` | `LeaderLilyCriteria_Expansion1` | `dlc/11_expansion1.sql` |
| `LE_Expansion2` | `LeaderLilyCriteria_Expansion2` | `dlc/12_expansion2.sql` |
| `LE_SecretSocieties` | `LE_SecretSocieties_EXPANSION` | `dlc/13_secret_societies.sql` |

这种拆分避免在基础规则集加载尚不存在的扩展表或对象，同时保持每个兼容模块可以独立验证。
