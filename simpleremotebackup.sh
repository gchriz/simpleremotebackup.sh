#!/usr/bin/env bash
#
# Simple backup program to copy a local directory to a remote server
# via 'sftp' protocol, using the program 'lftp'.
# Optionally an (e.g.) rotating version strategy can be configured.
# See VERSIONDIR below.
#
# When connecting to a remote server for the first time, lftp might complain or hang.
# Please use an initial manual 'ssh user@server' to complete the "known-hosts" dialog.
#
# Have fun, but use this script on your own risk! No warranties at all.


which lftp >/dev/null 2>&1
if [ $? -ne 0 ] ; then
    echo "Error: The program 'lftp' is required."
    echo "Please install it with e.g.:  sudo apt install lftp"
    exit 2
fi

# ---------- Configuration - Start

# the source directory to be saved
SRCDIR=~/tmp/data

# the target server, optionally with a port number (default: 22)
#TGTSRV=pialu:22
TGTSRV=pialu

# user and password on the target server
TGTUSR=pi
# if the password is "" (empty string), the script asks for the password interactively
# Helpful during testing...
TGTPW=""

# or the password might be right here in the script:
#TGTPW=bad_idea
#
# (But there are far better solutions for configuring/storing the password!
#  See man pages of lftp, .netrc, ssh-keygen, ssh-copy-id, ssh-add)

# the directory on the target server
TGTDIR=/home/pi/data-backup

# ----------
# Optional versioning strategy.
# Choose one and comment out the others.
# Or create other variations. Reading 'man date' may help and inspire you.
#
VERSIONDIR=""                  # no versioning, one target directory
#VERSIONDIR=$(date +'%F')       # one subdirectory for every date (YYYY-MM-DD)
#VERSIONDIR=$(date +'%u')       # one subdirectory for every day of week (1..7)
#VERSIONDIR=$(date +'W%V/%u')   # one subdirectory per week (W01..W53) with sub-subdirectories per day of week (1..7)
#VERSIONDIR=$(date +'M%m/%d')   # one subdirectory per month (01..12) with sub-subdirectories per day (01..31)
#
# Example with two files to save from 'SRCDIR':
# On 'Sun Mar 6 2022' the above types of VERSIONDIR would produce
# in the target directory 'TGTDIR':
#
#  ├── file1.txt
#  ├── file2.txt
#
#  ├── 2022-03-06
#  │   ├── file1.txt
#  │   └── file2.txt
#
#  ├── 7
#  │   ├── file1.txt
#  │   └── file2.txt
#
#  ├── W09
#  │   └── 7
#  │       ├── file1.txt
#          └── file2.txt
#  ├── M03
#  │   └── 06
#  │       ├── file1.txt
#  │       └── file2.txt

# ---------- Configuration - End

# if there is a password given, prepend a colon for later use in lftp
[ -n "${TGTPW}" ] && TGTPW=":${TGTPW}"

if [ ! -d ${SRCDIR} ] ; then
    echo "ERROR: ${SRCDIR} not found!"
    exit 1
fi


LFTP_CFG="set net:timeout 5; set net:max-retries 1;"
LFTP_CMD="mirror --reverse --verbose"
LFTP_SRV=sftp://${TGTUSR}${TGTPW}@${TGTSRV}
LFTP_DIR=${TGTDIR}/${VERSIONDIR-}

echo "Copying '${SRCDIR}' to '${TGTUSR}@${TGTSRV}:${LFTP_DIR}'"

lftp -e "${LFTP_CFG}; lcd ${SRCDIR} && ${LFTP_CMD} -O ${LFTP_DIR} ; quit" ${LFTP_SRV}

