#!/usr/bin/env bash
# Run EPUBCheck over every book in the suite and fail if any book has errors.
#
#   util/epubcheck-all.sh path/to/epubcheck.jar
#   EPUBCHECK_JAR=path/to/epubcheck.jar util/epubcheck-all.sh
#
# Each book is checked in expanded mode, straight from its source directory.
# Warnings are printed but do not fail the run: the suite deliberately keeps
# some deprecated constructs because reading systems are tested against them.
# When run under GitHub Actions, a summary table is added to the job summary.

set -uo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
jar=${1:-${EPUBCHECK_JAR:-}}
if [ -z "$jar" ] || [ ! -f "$jar" ]; then
  echo "usage: $0 path/to/epubcheck.jar  (or set EPUBCHECK_JAR)" >&2
  exit 2
fi

books=("$root"/content/30/epub30-test-* "$root"/content/parked-tests/epub30-test-*)
failed=()
total_errors=0
total_warnings=0
summary=$'| Book | Errors | Warnings |\n|---|---:|---:|\n'

echo "EPUBCheck: $(java -jar "$jar" --version 2>&1 | head -n 1)"
echo

for book in "${books[@]}"; do
  [ -d "$book" ] || continue
  name=${book#"$root"/content/}

  output=$(java -jar "$jar" --mode exp -q "$book" 2>&1)
  status=$?
  errors=$(grep -c -E '^(FATAL|ERROR)' <<<"$output")
  warnings=$(grep -c '^WARNING' <<<"$output")
  total_errors=$((total_errors + errors))
  total_warnings=$((total_warnings + warnings))

  printf '%-36s errors=%-3s warnings=%s\n' "$name" "$errors" "$warnings"
  [ -n "$output" ] && sed 's/^/    /' <<<"$output"

  if [ "$status" -ne 0 ] || [ "$errors" -gt 0 ]; then
    failed+=("$name")
  fi
  summary+="| $name | $errors | $warnings |"$'\n'
done

echo
echo "Total: ${#books[@]} books, $total_errors errors, $total_warnings warnings"

if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
  {
    echo "## EPUBCheck"
    echo
    echo "$total_errors errors and $total_warnings warnings across ${#books[@]} books."
    echo
    echo "$summary"
  } >> "$GITHUB_STEP_SUMMARY"
fi

if [ "${#failed[@]}" -gt 0 ]; then
  echo "Books with errors: ${failed[*]}" >&2
  exit 1
fi
