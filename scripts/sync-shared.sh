#!/usr/bin/env bash
# Copies each file in shared/ over every file with the same name in skills/*/references/.
# A skill opts in to a shared file by keeping a copy of it in its references/ folder.
# With --check nothing is written; the script exits 1 if any copy is out of date.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
check=false
[[ "${1:-}" == "--check" ]] && check=true
stale=0

for source in "$root"/shared/*; do
  name="$(basename "$source")"
  for copy in "$root"/skills/*/references/"$name"; do
    [[ -e "$copy" ]] || continue
    cmp -s "$source" "$copy" && continue
    if $check; then
      echo "out of date: ${copy#"$root"/}"
      stale=1
    else
      cp "$source" "$copy"
      echo "updated: ${copy#"$root"/}"
    fi
  done
done

exit "$stale"
