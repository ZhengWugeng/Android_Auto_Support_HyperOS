# Android Auto Support HyperOS

A KernelSU module release for Android Auto `18.1.664404-release` on ARM64 Android 15 and newer devices running HyperOS. The project keeps the original HyperOS support files and packages the complete signed Android Auto split APK in the same release ZIP.

Maintainer: `2.236`
Original module attribution: `相见即是缘`

## Install

1. Download `AndroidAuto_18.1.664404-release_2.236.zip` from the GitHub Release.
2. In KernelSU, install the ZIP as a module.
3. Reboot manually after the module installer reports success.
4. Check that Android Auto is visible in Settings and that `pm path com.google.android.projection.gearhead` points to the installed `/data/app` package.

The module does not automatically downgrade a newer Android Auto installation or clear Android Auto data. Use one Android Auto version at a time.

## Package layout

- `module/app/`: the four Android Auto split APKs used by the installer.
- `module/system/`: the original overlay, privileged permission allowlist, and renamed support stub directory.
- `module/customize.sh`: checks API/ABI and streams the split APKs into Android Package Manager.
- `release/`: the ZIP attached to the release and its SHA256 file.
- `tools/build_release.py`: deterministic package and checksum builder used by the GitHub workflow.

The support stub directory is named `AndroidAutoSupportStub_Restore` to avoid reusing the stale `AndroidAutoStub` parsed-package cache observed during diagnosis. The full app is installed through Package Manager so app processes can read it from `/data/app`.

## Environment

- Device: Xiaomi 17 Pro Max (`2509FPN0BC`), HyperOS `OS4.0.6.0.XPBCNXM`, Android 17.
- Root and LSPosed: KernelSU; LSPosed modern API, installed framework API 102.

## Build and release

Requires Python 3. The release workflow runs `python tools/build_release.py` and uploads the generated ZIP and `SHA256SUMS.txt`. A tag matching `v*` creates a GitHub Release through the repository's GitHub Actions workflow.

```powershell
python .\tools\build_release.py
Get-FileHash .\release\AndroidAuto_18.1.664404-release_2.236.zip -Algorithm SHA256
```

## References

- [KernelSU module guide](https://kernelsu.org/guide/module.html)
- [KernelSU metamodule guide](https://kernelsu.org/guide/metamodule.html)
- [Android privileged permission allowlist](https://source.android.com/docs/core/permissions/perms-allowlist)
- [Android Auto 18.1.664404 source package](https://www.apkmirror.com/apk/google-inc/android-auto/android-auto-18-1-6644-release/android-auto-18-1-664404-release-2-android-apk-download/)

For the Chinese README, see [README.zh-CN.md](README.zh-CN.md).
