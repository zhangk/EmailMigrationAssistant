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

# 构建imapsync命令
CMD="imapsync \\
  --host1 \"$HOST1\" --user1 \"$USER1\" --password1 \"$PASS1\" \\
  --host2 \"$HOST2\" --user2 \"$USER2\" --password2 \"$PASS2\" \\
  --automap --syncinternaldates"

# 关键选项选择
safe_input "Perform dry run? (y/n) [y]: " DRY_RUN
DRY_RUN=${DRY_RUN:-y}

# 添加选项
if [[ "$DRY_RUN" =~ ^[Yy]$ ]]; then
    CMD+=" --dry"
    echo "⚠️  DRY RUN MODE: No actual changes will be made"
else
    safe_input "Delete source emails after migration? (y/n) [n]: " DELETE_SOURCE
    DELETE_SOURCE=${DELETE_SOURCE:-n}
    if [[ "$DELETE_SOURCE" =~ ^[Yy]$ ]]; then
        CMD+=" --delete1"
        CMD+=" --expunge1"
        echo "⚠️  WARNING: Source emails will be DELETED after migration!"
    fi
fi

# 添加其他常用选项
CMD+=" --exclude \"Deleted Messages|Drafts|Junk\""
CMD+=" --maxsize 50000000"  # 跳过大于50MB的邮件
CMD+=" --useuid"
CMD+=" --nofoldersizes"
CMD+=" --nofoldersizesatend"
CMD+=" --nochecknoabletosearch"

# 执行迁移
echo "Starting migration..."
eval "$CMD"
MIGRATION_RESULT=$?

if [[ $MIGRATION_RESULT -eq 0 ]]; then
    echo -e "\n✅ Migration completed successfully!"
else
    echo -e "\n❌ Migration failed with error code $MIGRATION_RESULT"
fi

# 安全清理
unset PASS1 PASS2
