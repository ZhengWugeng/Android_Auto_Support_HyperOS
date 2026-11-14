# Changelog

## 2.236

- Packaged Android Auto 18.1.664404 as a full split APK module.
- Kept the original HyperOS overlay, privileged permission allowlist, and support stub.
- Installed the full app through Package Manager to avoid app-process visibility problems caused by module-only APK mounting.
- Added English and Chinese repository documentation, checksum files, and a tag-driven GitHub Release workflow.

## Validation

- APK payload bytes and signer certificate were preserved from the previously verified 18.1 candidate.
- ZIP CRC and runtime module SHA256 checks passed on 2026-11-14.
- No phone or car installation was performed for this repository packaging step.
