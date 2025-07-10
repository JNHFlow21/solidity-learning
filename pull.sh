#!/bin/bash

# Git 智能拉取脚本：自动识别当前分支并从远程仓库拉取更新
# 功能：获取当前分支名 → 从远程仓库拉取对应分支更新
# 使用方法：将此脚本放在 Git 仓库根目录下，运行 `./pull.sh` 即可

# 获取当前分支名
current_branch=$(git rev-parse --abbrev-ref HEAD)

echo "🔍 当前分支：$current_branch"
echo "⬇️ 正在从 origin/$current_branch 拉取更新..."

# 拉取对应分支更新
git pull origin "$current_branch"

# 检查是否成功
if [ $? -eq 0 ]; then
  echo "✅ 拉取完成：本地 $current_branch 分支已是最新版本。"
else
  echo "❌ 拉取失败，请检查冲突或网络问题。"
fi