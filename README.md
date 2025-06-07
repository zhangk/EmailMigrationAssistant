## Email Migration Assistant
![shell](https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)  
A secure, interactive IMAP email migration tool built on the powerful imapsync utility. Provides a user-friendly command-line interface with options for dry runs, source email deletion, and comprehensive migration control.
## Key Features
### 🔐 Security First
*  Interactive password input (no echo)
*  Sensitive data stored only in memory
*  Automatic credential cleanup post-migration
### 🛡️ Controlled Migration
*  Dry run simulation mode
*  Optional source email deletion
### ⚡ Efficient & Smart
*  Automatic folder mapping (--automap)
*  Junk/Drafts folder exclusion
*  Large file filtering (>50MB by default)
### 📝 Comprehensive Logging
*  Detailed operation records
*  Error handling with retry mechanism
*  Clear migration result reporting
## Installation & Usage
### Prerequisites
*  imapsync installed [(Installation Guide)](https://imapsync.lamiral.info/#install)
*  Bash 4.0+ environment
### Quick Start
```bash
# 1. Download script
curl -O https://raw.githubusercontent.com/zhangk/EmailMigrationAssistant/refs/heads/master/email_migration.sh

# 2. Make executable
chmod +x email_migration.sh

# 3. Run migration assistant
./email_migration.sh
```
### Usage Workflow
#### 1. Enter source email details
*  IMAP server (e.g., imap.gmail.com)
*  Email address
*  Password (secure input)
#### 2. Enter destination email details
*  IMAP server (e.g., outlook.office365.com)
*  Email address
*  Password (secure input)
#### 3. Configure migration options
*  Enable dry run (default: yes)
*  Delete source emails after migration (default: no)
### Command-Line Options (Advanced)
```bash
# Non-interactive mode (testing only - NOT recommended)
DRY_RUN=n DELETE_SOURCE=y \
./email_migration.sh
```
## Migration Process Demo
```plaintext
Source IMAP server (e.g., imap.gmail.com): imap.gmail.com
Source email address: user@example.com
Source password: **********

Destination IMAP server: outlook.office365.com
Destination email address: newuser@domain.com
Destination password: **********

Perform dry run? (y/n) [y]: n
Delete source emails after migration? (y/n) [n]: y
Skip folder size calculation? (y/n) [y]: y

===== Final Command =====
imapsync --host1 "imap.gmail.com" --user1 "user@example.com" ...
==========================
Execute migration now? (y/n) [y]: y

Starting migration...
[ 2025-06-07 14:30:00 ] Syncing INBOX: 1247 messages
[ 2025-06-07 14:32:15 ] Syncing Sent: 876 messages
...
✅ Migration completed successfully! Transferred 2.1GB across 2123 messages.
```
## Security Considerations
### 1. Password Security
*  Passwords never stored on disk
*  Immediate memory cleanup post-migration
*  Recommended to run in trusted environments
### 2. Dangerous Operation Protection
*  Source deletion requires explicit confirmation
*  Dry run mode enabled by default
### 3. Two-Factor Authentication Accounts
```plaintext
For 2FA-enabled accounts (e.g., Gmail):
1. Visit https://myaccount.google.com/apppasswords
2. Generate application-specific password
3. Use this password during input
```
**Important Notice**: Always backup critical data before migration. The author is not responsible for data loss.
