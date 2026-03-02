# CI/CD 说明

## 已配置的流水线

### 1. CI（`.github/workflows/ci.yml`）

- **触发**：推送到 `main`/`master` 或向该分支提 PR 时自动运行。
- **步骤**：
  - 检出代码 → 配置 Flutter（stable、缓存）→ `flutter pub get`
  - **分析**：`flutter analyze --no-fatal-infos`
  - **测试**：`flutter test`
  - **构建**：构建 Debug APK 并上传为 Artifact，可在该次运行的 “Summary → Artifacts” 中下载。

### 2. CD（`.github/workflows/cd.yml`）

- **触发**：
  - 在 GitHub 上 **创建并发布 Release** 时：会构建 release APK 与 AAB，并上传到该 Release 的附件。
  - **手动触发**：在仓库 **Actions** 页选择 “CD” 工作流，点击 “Run workflow”，构建产物会作为 Artifact 提供下载。
- **说明**：当前为无签名 release 构建。若需正式签名（上架商店），请在仓库 **Settings → Secrets and variables → Actions** 中配置签名相关 Secret，并在 `android/app/build.gradle.kts` 中配置 `signingConfigs` 使用这些变量。

## 使用前提

1. 代码已推送到 **GitHub**（流水线按 GitHub Actions 编写）。
2. 默认分支为 `main` 或 `master`；若不同，请修改各 workflow 中 `on.push / on.pull_request` 的 `branches`。

## 使用其他 CI/CD 平台时

- **GitLab**：可把步骤改为 `image: cirrusci/flutter` 或自建 Flutter 镜像，按同样顺序执行 `flutter pub get`、`analyze`、`test`、`build apk`。
- **Jenkins / 自建**：需在节点上安装 Flutter SDK，并执行上述命令；产物可通过 “Archive the artifacts” 或上传到对象存储/分发服务。

## 分支名与 Flutter 版本

- 若主分支名不是 `main`/`master`，请编辑 `.github/workflows/ci.yml` 里 `on.push.branches` 和 `on.pull_request.branches`。
- 如需固定 Flutter 版本，可在 `subosito/flutter-action` 的 `with` 中增加 `version: 'x.x.x'`（或使用 `flutter-version-file: pubspec.yaml` 等，见该 Action 文档）。
