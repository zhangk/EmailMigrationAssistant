中文 | [English](README_EN.md)
## 邮件迁移助手
![shell](https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)  
一个安全、交互式的IMAP邮箱迁移工具，基于强大的imapsync封装，提供用户友好的命令行界面，支持试运行、源邮件删除等高级选项，确保邮箱迁移过程完全可控。
## 主要特性
### 🔐 安全第一
- 密码交互式输入（不回显）
- 敏感信息仅存内存
- 迁移后自动清除凭证
### 🛡️ 可控迁移
- 支持试运行（dry run）模式
- 可选的源邮件删除功能
- 迁移前二次确认
### ⚡ 高效智能
- 自动文件夹映射（--automap）
- 跳过垃圾邮件文件夹
- 大文件过滤（默认>50MB）
- 文件夹大小计算优化
### 📝 完整日志
- 详细操作记录
- 错误处理与重试机制
- 清晰的迁移结果报告
## 安装与使用
### 前置要求
- imapsync 已安装 [(安装指南)](https://imapsync.lamiral.info/#install)
- Bash 4.0+ 环境
### 快速开始
```bash
# 1. 下载脚本
curl -O https://raw.githubusercontent.com/zhangk/EmailMigrationAssistant/refs/heads/master/email_migration.sh

# 2. 添加执行权限
chmod +x email_migration.sh

# 3. 运行迁移助手
./email_migration.sh
```
### 使用流程
#### 1. 输入源邮箱信息
*  IMAP服务器地址（如imap.exmail.qq.com）
*  邮箱地址
*  密码（安全输入）
#### 2. 输入目标邮箱信息
*  IMAP服务器地址（如imap.qq.com）
*  邮箱地址
*  密码（安全输入）
#### 3. 配置迁移选项
*  是否启用试运行（默认：是）
*  是否迁移后删除源邮件（默认：否）
#### 4. 确认并执行
*  查看生成的完整命令
*  最终确认后开始迁移
### 命令行选项（高级）
```bash
# 非交互式模式（不推荐，仅用于测试）
DRY_RUN=n DELETE_SOURCE=y SKIP_FOLDER_SIZE=n \
./email_migration.sh
```
## 迁移过程
```plaintext
Source IMAP server (e.g., imap.exmail.qq.com): imap.exmail.qq.com
Source email address: user@example.com
Source password: **********

Destination IMAP server (e.g., imap.qq.com): imap.qq.com
Destination email address: newuser@domain.com
Destination password: **********

Perform dry run? (y/n) [y]: n
Delete source emails after migration? (y/n) [n]: y
Skip folder size calculation? (y/n) [y]: y

===== Final Command (passwords hidden) =====
imapsync --host1 "imap.exmail.qq.com" --user1 "user@example.com" --password1 "******" \
  --host2 "imap.qq.com" --user2 "newuser@domain.com" --password2 "******" \
  --automap --syncinternaldates --delete1 --nofoldersizes \
  --exclude "(?i)spam|trash|junk" --maxsize 50000000
imapsync \
  --host1 "imap.exmail.qq.com" --user1 "user@example.com" --password1 "******" \
  --host2 "imap.qq.com" --user2 "newuser@domain.com" --password2 "******" \
  --automap --syncinternaldates --nofoldersizes --exclude "Deleted Messages|Drafts|Junk" --maxsize 50000000 --useuid
============================================
Execute migration now? (y/n) [y]: y

Starting migration...
[imapsync output...]
```
## 安全注意事项
### 1. 密码安全
*  密码不会存储在磁盘上
*  迁移结束后立即从内存清除
*  建议在受信任的安全环境中运行
### 2. 危险操作保护
*  删除源邮件需要明确确认
*  试运行模式默认开启
*  关键操作前提供二次确认
### 3. 双因素认证账户
```plaintext
对于启用2FA的邮箱（如Gmail）：
1. 访问 https://myaccount.google.com/apppasswords
2. 生成应用专用密码
3. 在密码输入时使用该专用密码
```
**温馨提示**：邮箱迁移前请确保已备份重要数据。本工具作者不对数据丢失负责。
