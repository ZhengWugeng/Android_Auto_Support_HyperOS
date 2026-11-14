# Android Auto Support HyperOS

这是一个面向 ARM64、Android 15 及以上 HyperOS 设备的 KernelSU 模块，内置 Android Auto `18.1.664404-release` 的完整分包，并保留原始 HyperOS 支持文件。

维护者：`2.236`
原模块作者署名：`相见即是缘`

## 安装

1. 从 GitHub Release 下载 `AndroidAuto_18.1.664404-release_2.236.zip`。
2. 在 KernelSU 中安装这个 ZIP。
3. 管理器报告成功后手动重启。
4. 在系统设置中检查 Android Auto 是否出现，并用 `pm path com.google.android.projection.gearhead` 确认普通应用路径位于 `/data/app`。

模块不会自动降级更高版本的 Android Auto，也不会清除 Android Auto 数据。一次只使用一个 Android Auto 版本。

## 目录

- `module/app/`：安装器使用的四个 Android Auto 分包 APK。
- `module/system/`：原始覆盖包、特权权限白名单和改名后的支持占位目录。
- `module/customize.sh`：检查 Android 版本和 ABI，并通过 Package Manager 安装分包。
- `release/`：发布 ZIP 和 SHA256 校验文件。
- `tools/build_release.py`：GitHub Actions 使用的打包和校验脚本。

支持占位目录改为 `AndroidAutoSupportStub_Restore`，用于避开排查时发现的旧 `AndroidAutoStub` 解析缓存。完整应用通过 Package Manager 安装到 `/data/app`，应用进程可以直接读取。

## 适配范围

- Android：15 / API 35 及以上。
- ABI：ARM64（`arm64-v8a`）。
- Android Auto：`18.1.664404-release`，版本号 `181664404`。
- 本次发布不宣称已经完成手机和车机实测；静态校验结果记录在 `module/BUILD_INFO.json`。

## 构建和发布

需要 Python 3。发布工作流执行 `python tools/build_release.py`，并上传生成的 ZIP 和 `SHA256SUMS.txt`。推送匹配 `v*` 的标签后，GitHub Actions 创建 Release。

```powershell
python .\tools\build_release.py
Get-FileHash .\release\AndroidAuto_18.1.664404-release_2.236.zip -Algorithm SHA256
```

## 参考资料

- [KernelSU 模块指南](https://kernelsu.org/guide/module.html)
- [KernelSU metamodule 指南](https://kernelsu.org/guide/metamodule.html)
- [Android 特权权限白名单](https://source.android.com/docs/core/permissions/perms-allowlist)
- [Android Auto 18.1.664404 来源包](https://www.apkmirror.com/apk/google-inc/android-auto/android-auto-18-1-6644-release/android-auto-18-1-664404-release-2-android-apk-download/)

英文 README： [README.md](README.md)。
