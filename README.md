# Mechanical DWG Annotator for Codex

一个面向机械行业三视图 DWG 的 Codex 插件。它使用本机 AutoCAD 兼容引擎分析图纸，添加图框、标题栏、中心线、中心标记和可由几何可靠确定的尺寸，并另存为新的 DWG。

## 功能

- 分析机械三视图及视图对应关系
- 参考内置 DWG 模板的图层与标注风格
- 添加图框、标题栏、尺寸、中心线和中心标记
- 避免覆盖源 DWG
- 不擅自推断公差、配合、粗糙度、材料和热处理要求
- 使用 AutoCAD Core Console 验证输出 DWG

## 系统要求

- Windows
- Codex
- AutoCAD 或提供 DWG 写入能力的兼容 CAD 引擎
- PowerShell

当前脚本会自动搜索 `C:\Program Files\Autodesk` 下的 `accoreconsole.exe`。

## 安装

克隆或下载本仓库后，在仓库根目录执行：

```powershell
codex plugin marketplace add .
codex plugin add mechanical-dwg-annotator@mechanical-cad-tools
```

安装后新建 Codex 任务，并输入：

```text
使用 $annotate-mechanical-dwg 完善附件中的机械零件三视图，保留源文件并输出新的 DWG。
```

## 目录

- `.agents/plugins/marketplace.json`：Codex marketplace 定义
- `plugins/mechanical-dwg-annotator/.codex-plugin/plugin.json`：插件清单
- `plugins/mechanical-dwg-annotator/skills/annotate-mechanical-dwg/`：Skill、脚本、参考资料和模板

## 重要说明

内置机械制图标准文件是标准体系索引，并非完整标准正文。涉及具体标准条款或生产放行时，请再使用权威标准文本核验。

请仅在确认有权公开和再分发内置 DWG 模板后，将仓库设为公开。

## 许可证

代码按 MIT License 发布。内置 DWG 模板和标准参考资料仅在其权利允许的范围内使用和再分发。
