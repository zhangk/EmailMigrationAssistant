#!/bin/bash

# 安全输入函数：带提示和换行控制
safe_input() {
    local prompt="$1"
    local var_name="$2"
    local is_password="$3"

    echo -n "$prompt"
    if [[ "$is_password" == "password" ]]; then
        read -s "$var_name"
        echo
    else
        read "$var_name"
    fi
}

# 收集基础信息
safe_input "Source IMAP server (e.g., imap.exmail.qq.com): " HOST1
safe_input "Source email address: " USER1
safe_input "Source password: " PASS1 password

safe_input "Destination IMAP server (e.g., imap.qq.com): " HOST2
safe_input "Destination email address: " USER2
safe_input "Destination password: " PASS2 password

# 关键选项选择
safe_input "Perform dry run? (y/n) [y]: " DRY_RUN
DRY_RUN=${DRY_RUN:-y}

safe_input "Delete source emails after migration? (y/n) [n]: " DELETE_SOURCE
DELETE_SOURCE=${DELETE_SOURCE:-n}

safe_input "Skip folder size calculation? (y/n) [y]: " SKIP_FOLDER_SIZE
SKIP_FOLDER_SIZE=${SKIP_FOLDER_SIZE:-y}

# 构建imapsync命令（显示版本）
CMD_DISPLAY="imapsync \\
  --host1 \"$HOST1\" --user1 \"$USER1\" --password1 \"******\" \\
  --host2 \"$HOST2\" --user2 \"$USER2\" --password2 \"******\" \\
  --automap --syncinternaldates"

# 构建实际执行命令（包含真实密码）
CMD_EXEC="imapsync \\
  --host1 \"$HOST1\" --user1 \"$USER1\" --password1 \"$PASS1\" \\
  --host2 \"$HOST2\" --user2 \"$USER2\" --password2 \"$PASS2\" \\
  --automap --syncinternaldates"

# 添加选项
if [[ "$DRY_RUN" =~ ^[Yy]$ ]]; then
    CMD_DISPLAY+=" --dry"
    CMD_EXEC+=" --dry"
    echo "⚠️  DRY RUN MODE: No actual changes will be made"
fi

if [[ "$DELETE_SOURCE" =~ ^[Yy]$ ]]; then
    CMD_DISPLAY+=" --delete1"
    CMD_DISPLAY+=" --expunge1"
    CMD_EXEC+=" --delete1"
    CMD_EXEC+=" --expunge1"
    echo "⚠️  WARNING: Source emails will be DELETED after migration!"
fi

if [[ "$SKIP_FOLDER_SIZE" =~ ^[Yy]$ ]]; then
    CMD_DISPLAY+=" --nofoldersizes"
    CMD_EXEC+=" --nofoldersizes"
fi

# 添加其他常用选项
CMD_DISPLAY+=" --exclude \"Deleted Messages|Drafts|Junk\""
CMD_DISPLAY+=" --maxsize 50000000"
CMD_DISPLAY+=" --useuid"
CMD_EXEC+=" --exclude \"Deleted Messages|Drafts|Junk\""
CMD_EXEC+=" --maxsize 50000000"
CMD_EXEC+=" --useuid"

# 确认执行
echo -e "\n===== Final Command (passwords hidden) ====="
echo "$CMD_DISPLAY"
echo "============================================"

safe_input "Execute migration now? (y/n) [y]: " CONFIRM_EXECUTE
CONFIRM_EXECUTE=${CONFIRM_EXECUTE:-y}

# 执行迁移
if [[ "$CONFIRM_EXECUTE" =~ ^[Yy]$ ]]; then
    echo "Starting migration..."
    eval "$CMD_EXEC"
    MIGRATION_RESULT=$?

    if [[ $MIGRATION_RESULT -eq 0 ]]; then
        echo -e "\n✅ Migration completed successfully!"
    else
        echo -e "\n❌ Migration failed with error code $MIGRATION_RESULT"
    fi
else
    echo "Migration canceled by user."
fi

# 安全清理
unset PASS1 PASS2 CMD_EXEC
echo "Passwords cleared from memory."
