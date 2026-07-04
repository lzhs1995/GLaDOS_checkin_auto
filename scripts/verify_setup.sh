#!/usr/bin/env bash
# 验证 GLaDOS GitHub Actions 签到配置
set -euo pipefail

REPO="${GLADOS_REPO:-lzhs1995/GLaDOS_checkin_auto}"

echo "== 仓库 =="
gh repo view "$REPO" --json url,defaultBranchRef -q '.url + " (" + .defaultBranchRef.name + ")"'

echo
echo "== Secrets =="
gh secret list -R "$REPO" || true

echo
echo "== Workflow =="
gh workflow list -R "$REPO"

echo
echo "== 最近 3 次运行 =="
gh run list -R "$REPO" --limit 3

echo
echo "手动触发签到:"
echo "  gh workflow run '开始每日签到' -R $REPO"