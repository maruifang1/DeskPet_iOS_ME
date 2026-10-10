# 宠物形象素材

## 命名规则

每张透明 PNG 对应一个 `PetMood`，代码通过 `UIImage(named: "frame.<mood>")` 查找：

- `frame.morning` / `frame.noon` / `frame.afternoon` / `frame.evening` / `frame.night`
- `frame.charging` / `frame.lowBattery`
- `frame.reactHappy` / `frame.reactSurprised` / `frame.reactSleepy`
- `frame.idle`（可选用作占位兜底）

## 添加步骤

1. 在 `PetAssets.xcassets` 内为每张图新建 `<名称>.imageset` 文件夹。
2. 把 PNG 放进去，命名 `frame.<mood>.png`。
3. 在对应 `Contents.json` 的 `images` 数组中加入：

```json
{
  "filename" : "frame.<mood>.png",
  "idiom" : "universal",
  "scale" : "1x"
}
```

建议使用 600x600 以上、透明背景的 PNG，WidgetKit 会按需缩放。没有素材时，App 会自动回退到 SwiftUI 绘制的占位形象，工程始终可运行。
