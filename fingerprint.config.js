// Controls what goes into the runtime version fingerprint (runtimeVersion.policy:
// 'fingerprint'). An OTA update only reaches builds with the same fingerprint.
const { SourceSkips } = require('expo/fingerprint');

/** @type {import('expo/fingerprint').Config} */
module.exports = {
  sourceSkips:
    // Default: package.json android/ios scripts that don't affect native code.
    SourceSkips.PackageJsonAndroidAndIosScriptsIfNotContainRun |
    // App version and build numbers. A version bump alone doesn't change native
    // code, so it shouldn't stop updates reaching the previous build.
    SourceSkips.ExpoConfigVersions |
    // .gitignore only matters for checked-in native folders; ios/ and android/
    // are generated at build time here.
    SourceSkips.GitIgnore,
};
