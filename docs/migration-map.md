# XML → SQL 迁移对应关系

原 Gameplay XML 继续保留在仓库中，作为审计和自动测试基线；`LeaderLily.civ6proj` 的运行时 `UpdateDatabase` 已切换到新 SQL。

## 已迁移模块

| 顺序 | 原文件 | 新文件 | 表数 | 行数 | 等价检查 |
| ---: | --- | --- | ---: | ---: | --- |
| 01 | `Data/Land's_End_Civilization.xml` | `Gameplay/SQL/01_civilization.sql` | 11 | 52 | PASS |
| 02 | `Data/Land's_End_Leader.xml` | `Gameplay/SQL/02_leader.sql` | 17 | 47 | PASS |
| 03 | `Data/Land's_End_District.xml` | `Gameplay/SQL/03_district.sql` | 17 | 44 | PASS |
| 04 | `Data/Land's_End_Units.xml` | `Gameplay/SQL/04_unit.sql` | 14 | 21 | PASS |
| 05 | `Data/Land's_End_Building.xml` | `Gameplay/SQL/05_building.sql` | 16 | 65 | PASS |
| 06 | `Data/Land's_End_Religion.xml` | `Gameplay/SQL/06_religion.sql` | 6 | 13 | PASS |
| 10 | `DLC/Land's_End_Babylon_Pack.xml` | `Gameplay/SQL/dlc/10_babylon_pack.sql` | 2 | 2 | PASS |
| 11 | `DLC/Land's_End_Expansion1.xml` | `Gameplay/SQL/dlc/11_expansion1.sql` | 2 | 4 | PASS |
| 12 | `DLC/Land's_End_Expansion2.xml` | `Gameplay/SQL/dlc/12_expansion2.sql` | 4 | 8 | PASS |
| 13 | `DLC/Land's_End_SecretSocieties.xml` | `Gameplay/SQL/dlc/13_secret_societies.sql` | 1 | 1 | PASS |
| | **合计** | **10 个 SQL 模块** | **90（模块内计数）** | **257** | **PASS** |

## 保留原格式

| 文件 / 目录 | 保留原因 |
| --- | --- |
| `Data/Land's_End_Config.xml` | FrontEnd Players / PlayerItems 配置，不属于本次 Gameplay 数据迁移 |
| `Data/Land's_End_Icon.xml` | 由 `UpdateIcons` 处理，而非 Gameplay `UpdateDatabase` |
| `Data/Land's_End_Color.xml` | 由 `UpdateColors` 处理 |
| `Text/*.xml` | 多语言本地化由 `UpdateText` 处理，XML 更适合维护语言 Tag/Text 结构 |
| `ArtDefs/*.artdef` | Civilization VI 美术定义专用格式 |
| `LeaderLily.Art.xml` | Mod Art Dependency 配置 |
| `Textures/`, `Assets/`, `XLPs/` | 二进制纹理、资产与打包定义，不是 SQLite Gameplay 数据 |
| `Platforms/Windows/Audio/` | Wwise 音频、曲目清单和本地生成路径；本地保留，公开源码仓库整体排除 |

## 加载配置变化

`LeaderLily.civ6proj` 只改动两类内容：

1. `LE_Data` 与 4 个条件化 DLC `UpdateDatabase` action 的文件路径从 XML 指向 SQL；
2. 将 10 个 SQL 文件加入 ModBuddy `Content` 项。

Action id、criteria、文件顺序、Icon/Text/Art/Color/Audio action 均保持不变。
