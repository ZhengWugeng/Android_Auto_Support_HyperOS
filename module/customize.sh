#!/system/bin/sh
SKIPUNZIP=0
TARGET_CODE=181664404
TARGET_VERSION="18.1.664404-release"
PKG=com.google.android.projection.gearhead
API_LEVEL=$(getprop ro.build.version.sdk)
case "$API_LEVEL" in
 ''|*[!0-9]*) abort "! Cannot determine Android API level." ;;
esac
[ "$API_LEVEL" -ge 35 ] || abort "! Android 15 or newer is required by the bundled overlay."
case "$(getprop ro.product.cpu.abilist)" in
 *arm64-v8a*) ;;
 *) abort "! ARM64 is required." ;;
esac
CURRENT=$(dumpsys package "$PKG" 2>/dev/null | sed -n 's/^[[:space:]]*versionCode=\([0-9][0-9]*\).*/\1/p' | head -n 1)
if [ -n "$CURRENT" ] && [ "$CURRENT" -gt "$TARGET_CODE" ]; then
 abort "! A newer Android Auto exists. No downgrade or data clearing was performed."
fi
( cd "$MODPATH" && sha256sum -c files.sha256 >/dev/null ) || abort "! Module checksum mismatch."
set_perm_recursive "$MODPATH" 0 0 0755 0644
ui_print "- Installing full Android Auto $TARGET_VERSION as a normal app."
# Stream APKs because Package Manager cannot directly read /data/adb payload paths.
RESULT=$(pm install-create -r --user 0 -S 47359317 2>&1) || abort "! Cannot create app install session: $RESULT"
SESSION=$(printf '%s\n' "$RESULT" | sed -n 's/.*\[\([0-9][0-9]*\)\].*/\1/p')
case "$SESSION" in
 ''|*[!0-9]*) abort "! Unexpected install session response: $RESULT" ;;
esac
for FILE in base.apk split_config.arm64_v8a.apk split_config.xxhdpi.apk split_config.zh.apk; do
 SIZE=$(wc -c < "$MODPATH/app/$FILE" | tr -d '[:space:]')
 RESULT=$(pm install-write -S "$SIZE" "$SESSION" "$FILE" - < "$MODPATH/app/$FILE" 2>&1)
 if [ "$?" -ne 0 ]; then
  pm install-abandon "$SESSION" >/dev/null 2>&1
  abort "! Failed to write $FILE: $RESULT"
 fi
done
RESULT=$(pm install-commit "$SESSION" 2>&1)
STATUS=$?
case "$RESULT" in
 *Success*) ;;
 *) STATUS=1 ;;
esac
if [ "$STATUS" -ne 0 ]; then
 pm install-abandon "$SESSION" >/dev/null 2>&1
 abort "! App installation failed: $RESULT"
fi
ui_print "- Full app installed in /data/app; original system support is included."
ui_print "- Reboot manually after module installation. App data was preserved."
