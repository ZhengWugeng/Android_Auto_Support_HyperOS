from pathlib import Path
import hashlib, json, zipfile

ROOT = Path(__file__).resolve().parents[1]
MODULE = ROOT / "module"
RELEASE = ROOT / "release"
ZIP_NAME = "AndroidAuto_18.1.664404-release_2.236.zip"

def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()

def refresh_manifest() -> None:
    lines = []
    for path in sorted(MODULE.rglob("*")):
        if not path.is_file():
            continue
        rel = path.relative_to(MODULE).as_posix()
        if rel == "files.sha256" or rel.startswith("META-INF/"):
            continue
        lines.append(f"{sha256(path)}  {rel}\n")
    (MODULE / "files.sha256").write_text("".join(lines), encoding="utf-8")

def main() -> None:
    refresh_manifest()
    RELEASE.mkdir(exist_ok=True)
    out = RELEASE / ZIP_NAME
    if out.exists():
        out.unlink()
    with zipfile.ZipFile(out, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=6) as archive:
        for path in sorted(MODULE.rglob("*")):
            if path.is_file():
                rel = path.relative_to(MODULE).as_posix()
                info = zipfile.ZipInfo(rel, (2026, 1, 1, 0, 0, 0))
                info.create_system = 3
                info.external_attr = 0o100644 << 16
                info.compress_type = zipfile.ZIP_DEFLATED
                archive.writestr(info, path.read_bytes())
    sums = RELEASE / "SHA256SUMS.txt"
    sums.write_text(f"{sha256(out)}  {out.name}\n", encoding="utf-8")
    with zipfile.ZipFile(out) as archive:
        assert archive.testzip() is None
    print(out)
    print(sha256(out))

if __name__ == "__main__":
    main()
