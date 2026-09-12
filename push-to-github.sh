#!/usr/bin/env bash
#
# Creates the public GitHub repo 'my-arena-site' and pushes this project.
#
# Usage:
#   GITHUB_TOKEN=<your_token> ./push-to-github.sh
#
# Token requirements: a classic PAT with the `repo` scope, or a fine-grained
# token with "Administration: Read & write" + "Contents: Read & write"
# (fine-grained tokens scoped to "All repositories", since the repo doesn't
# exist yet). Revoke the token after pushing if you pasted it anywhere.
#
set -euo pipefail
cd "$(dirname "$0")"

if [[ -z "${GITHUB_TOKEN:-}" ]]; then
  echo "ERROR: set GITHUB_TOKEN, e.g.  GITHUB_TOKEN=ghp_xxx ./push-to-github.sh" >&2
  exit 1
fi

echo "==> Validating token and fetching GitHub username..."
USERNAME=$(curl -sf -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/user | python3 -c 'import sys,json;print(json.load(sys.stdin)["login"])')
echo "    Authenticated as: ${USERNAME}"

REPO="my-arena-site"
echo "==> Creating public repo ${USERNAME}/${REPO} (if it doesn't exist)..."
HTTP_CODE=$(curl -s -o /tmp/repo-create.json -w "%{http_code}" \
  -X POST -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/user/repos \
  -d "{\"name\":\"${REPO}\",\"private\":false,\"description\":\"DARKSIDE — SPC Class 12 | An Original Documentary\",\"auto_init\":false}")
case "$HTTP_CODE" in
  201) echo "    Repo created." ;;
  422) echo "    Repo already exists — will push to it." ;;
  *)   echo "ERROR: repo creation failed (HTTP ${HTTP_CODE}):"; cat /tmp/repo-create.json >&2; exit 1 ;;
esac

# Embed token in remote URL only for the push, then scrub it.
git remote remove origin 2>/dev/null || true
git remote add origin "https://x-access-token:${GITHUB_TOKEN}@github.com/${USERNAME}/${REPO}.git"

echo "==> Pushing branch 'main'..."
git push -u origin main
PUSH_RESULT=$?

git remote set-url origin "https://github.com/${USERNAME}/${REPO}.git"
echo
echo "==> Done! Token removed from git config."
echo "    Repo: https://github.com/${USERNAME}/${REPO}"
echo "    Enable GitHub Pages: Settings -> Pages -> Branch: main / root"
exit $PUSH_RESULT
