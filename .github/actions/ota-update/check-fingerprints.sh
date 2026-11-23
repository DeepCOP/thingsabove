#!/usr/bin/env bash
# Checks that every platform's local fingerprint matches a finished EAS build of
# the given profile. An OTA update can only run on a build with the same
# fingerprint, so a mismatch means native code changed and a new store build is
# needed before this commit can ship over the air.
#
# Usage: check-fingerprints.sh <build-profile>   (preview | production)
set -euo pipefail

profile="$1"
summary="${GITHUB_STEP_SUMMARY:-/dev/stdout}"
mismatch=0

json_field() {
  # Prints a field from JSON on stdin. Skips any log lines before the JSON.
  node -e '
    let s = "";
    process.stdin.on("data", (d) => (s += d)).on("end", () => {
      const start = s.search(/^[[{]/m);
      const value = process.argv[1].split(".").reduce((o, k) => (o == null ? o : o[k]), JSON.parse(s.slice(start)));
      process.stdout.write(value == null ? "" : String(value));
    });
  ' "$1"
}

{
  echo "## OTA fingerprint check: \`$profile\`"
  echo
  echo "| Platform | Fingerprint of this commit | Matching \`$profile\` build |"
  echo "| --- | --- | --- |"
} >> "$summary"

details=""
for platform in android ios; do
  hash=$(eas fingerprint:generate --platform "$platform" --build-profile "$profile" --json --non-interactive | json_field hash)
  build=$(eas build:list --platform "$platform" --build-profile "$profile" --fingerprint-hash "$hash" \
    --status finished --limit 1 --json --non-interactive | json_field 0.id)

  if [ -n "$build" ]; then
    echo "| $platform | \`${hash:0:12}\` | [found](https://expo.dev/accounts/things-above/projects/thingsabove/builds/$build) |" >> "$summary"
    continue
  fi

  mismatch=1
  echo "| $platform | \`${hash:0:12}\` | :x: none |" >> "$summary"
  echo "::error title=Fingerprint mismatch ($platform)::No finished '$profile' $platform build has fingerprint $hash. Native code changed since the last build, so this commit needs a new store build before it can ship over the air."

  latest=$(eas build:list --platform "$platform" --build-profile "$profile" --status finished \
    --limit 1 --json --non-interactive | json_field 0.id)
  if [ -n "$latest" ]; then
    diff=$(eas fingerprint:compare --build-id "$latest" --environment "$profile" --non-interactive 2>/dev/null |
      grep -vE '^(Environment variables|🔧|- Computing|✔ Computed)' || true)
    [ -n "$diff" ] || diff="Could not compare fingerprints; see the job log."
    details+=$'\n'"<details><summary>$platform: what changed since the latest <code>$profile</code> build</summary>"$'\n\n```\n'"$diff"$'\n```\n</details>\n'
  fi
done

if [ "$mismatch" -eq 1 ]; then
  {
    echo
    echo "**OTA update not published.** Native code changed since the last \`$profile\` build."
    echo "Make a new \`$profile\` build first (push a release tag), then later merges can ship over the air again."
    echo "$details"
  } >> "$summary"
  exit 1
fi

echo >> "$summary"
echo "All platforms match an existing \`$profile\` build." >> "$summary"
