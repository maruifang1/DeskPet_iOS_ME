# DeskPet - iOS 主屏互动桌宠

依据 [../ios-deskpet-plan.md](../ios-deskpet-plan.md) 分阶段实现。当前进度：P1-P4 已完成（工程骨架、共享逻辑、小组件、宿主 App、黑银 Q 版形象 PNG 帧）；P5 通过 GitHub Actions 云端构建 + AltStore 安装，Windows 上即可完成。

## 阶段

| 阶段 | 内容 | 状态 |
| --- | --- | --- |
| P1 | XcodeGen 工程 + 共享核心逻辑 | 完成 |
| P2 | WidgetKit 小组件（timeline / 互动 / 占位形象） | 完成 |
| P3 | 宿主 App（预览 / 今日碎念 / 电池 / 刷新） | 完成 |
| P4 | 专属 Q 版形象 | 完成：10 张透明 PNG 表情帧 + 预览图 |
| P5 | 云端构建 + AltStore 安装 | GitHub Actions 公共仓库，Windows 可操作 |

## 目录结构

```text
ios-deskpet/
  project.yml            XcodeGen 工程描述
  DeskPet/               宿主 App（SwiftUI）
  DeskPetWidget/         WidgetKit 小组件扩展
  Shared/                两个 target 共用的逻辑与角色视图
  PetAssets/             宠物 PNG 表情帧（见 PetAssets/README.md）
  .github/workflows/      GitHub Actions 云端构建（产出未签名 IPA）
  reference/             你的形象参考图放置处
```

## P4：提供形象参考图（需要你做的）

1. 准备一张清晰的参考图（正面/半身照或 OC 立绘）。
2. 放到 `reference/reference.png`，告诉我气质关键词与主色调。
3. 已生成 Q 版角色设定 + 10 张透明 PNG 表情帧（`PetAssets/PetAssets.xcassets/frame.<mood>.imageset`）。

## P5：GitHub Actions 云端构建 + AltStore 安装（需要你做的）

1. 在 GitHub 创建一个 **公共仓库**（Public），不要把本目录拷到 Mac，直接在 Windows 上操作。
2. 打开终端进入 `ios-deskpet`，初始化并推送：
   ```bash
   git init
   git branch -M main
   git add .
   git commit -m "DeskPet iOS"
   git remote add origin https://github.com/<你的用户名>/<仓库名>.git
   git push -u origin main
   ```
3. 仓库页面打开 **Actions** 标签，工作流 `Build DeskPet unsigned IPA` 会自动运行（也可手动 `Run workflow`）。
4. 构建完成后进入本次运行的 **Artifacts**，下载 `DeskPet-unsigned-ipa`，解压得到 `DeskPet-unsigned.ipa`。
5. 在 Windows 安装 [AltStore](https://altstore.io) 需要的 AltServer，并按官网步骤用 Apple ID 把 AltStore 装到 iPhone。
6. 把 `DeskPet-unsigned.ipa` 传到 iPhone（隔空投送/网盘/文件 App），用 AltStore 打开并安装，AltStore 会用你的免费 Apple ID 签名。
7. 验收：长按主屏空白处 → 点 + → 搜索 DeskPet → 添加小组件；点按三个反应按钮换表情；充电/时段切换验证形象与碎念。

免费 Apple ID 签名有效期 7 天，连接 AltServer 可自动续签。若安装时提示扩展签名失败，说明免费签名不允许小组件扩展，可去掉 `DeskPetWidget` target 依赖后只装宿主 App。

## 平台限制

iOS 不允许悬浮覆盖其它 App，也没有连续动画、拖拽或前台 App/截图感知；本项目的互动由 iOS 17+ 小组件 App Intent 提供，状态通过 App Group 共享。

## 免费账号与 AltStore 分发

- 工程已去掉两个 target 的 App Group entitlements，适配免费 Apple ID 的 7 天 AltStore 签名；WidgetKit 扩展在免费签名下可用。
- 没有 App Group 时，App 与小组件各自读写本地 `UserDefaults`：小组件内的点按反应、时段表情、每日碎念正常，但宿主 App 的「今日碎念」与小组件不再跨进程共享。
- 若后续购买付费开发者账号上架 App Store / TestFlight，可在 `project.yml` 恢复 App Group entitlements，共享逻辑代码无需改动。

## 来源与协议

架构思路与功能清单借鉴 [AI-Live-Overflow](https://github.com/Vael-KY/AI-Live-Overflow)，遵循 CC BY-NC-SA 4.0（非商用、署名、同协议分享）。
