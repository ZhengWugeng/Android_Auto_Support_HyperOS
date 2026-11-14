# Validation record

Date: 2026-11-14

- The four APK split files are byte-preserved from the previously verified 18.1 candidate.
- The APK signer certificate and 16 KB alignment were verified before this repository packaging step.
- The release ZIP passes ZIP CRC validation.
- The module runtime file checksum manifest passes after extracting without `META-INF`, matching KernelSU module extraction behavior.
- No device or car installation was performed for this repository packaging step.
