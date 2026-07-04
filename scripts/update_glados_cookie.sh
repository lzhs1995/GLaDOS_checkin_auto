#!/usr/bin/env bash
# 从剪贴板或参数更新 GitHub Secret: GLADOS_COOKIE
set -euo pipefail

REPO="${GLADOS_REPO:-lzhs1995/GLaDOS_checkin_auto}"
SECRET_NAME="GLADOS_COOKIE"

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  cat <<'EOF'
用法:
  ./scripts/update_glados_cookie.sh 'koa:sess=...; other=...'
  pbpaste | ./scripts/update_glados_cookie.sh

获取 Cookie:
  1. 登录 https://glados.rocks/console/checkin
  2. F12 → Application → Cookies → glados.rocks
  3. 复制全部 Cookie（格式: name=value; name2=value2）
EOF
  exit 0
fi

if [[ -n "${1:-}" ]]; then
  COOKIE="$1"
elif [[ -t 0 ]]; then
  echo "请粘贴 GLaDOS Cookie 后按 Enter:" >&2
  IFS= read -r COOKIE
else
  COOKIE="$(cat)"
fi

COOKIE="$(printf '%s' "$COOKIE" | tr -d '\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

if [[ -z "$COOKIE" ]]; then
  echo "错误: Cookie 为空" >&2
  exit 1
fi

if [[ "$COOKIE" != *"koa:sess="* ]]; then
  echo "警告: Cookie 中未找到 koa:sess，可能不完整或已过期" >&2
fi

printf '%s' "$COOKIE" | gh secret set "$SECRET_NAME" -R "$REPO"
echo "已更新 $REPO 的 secret: $SECRET_NAME"
echo "触发签到: gh workflow run '开始每日签到' -R $REPO"