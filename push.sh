#!/bin/bash

# 交互式 Git 自动提交脚本
# 功能：添加所有更改 → 手动输入提交信息 → 推送到 GitHub main 分支

# 显示当前状态
echo "📦 当前 Git 状态："
git status
echo

# 添加所有更改
git add .

# 提示用户输入 commit 信息
read -p "📝 请输入提交信息: " msg

# 如果没输入，就使用默认时间戳提交
if [[ -z "$msg" ]]; then
  msg="自动提交：$(date '+%Y-%m-%d %H:%M:%S')"
fi

# 提交
git commit -m "$msg"

# 推送
echo "🚀 正在推送到 GitHub..."
git push origin main

echo "✅ 推送完成：$msg"