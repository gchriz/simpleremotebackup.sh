#!/usr/bin/env bash
#
# Simple backup script to copy a local directory to a remote server
# via 'sftp' protocol, using the program 'lftp'.
#
# Optionally an (e.g.) rotating version strategy can be configured.
# See VERSIONDIR below.
#
# When connecting to a remote sftp server for the first time,
# lftp might complain or hang. Please use an initial manual
# 'ssh user@target-server' to complete the "known-hosts" dialog.
#
# Have fun, but use this script on your own risk! No warranties at all.

# ---------- Configuration - Start

# the source directory to be saved
SRCDIR=~/important/data

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

# the root directory for the backups on the target server
TGTROOTDIR=/home/pi/backups

# how to construct the target directory
#TGTCREATEBASEDIR=no       # creates .../backups/<version>/<sourcedir's contents>
TGTCREATEBASEDIR=yes      # creates .../backups/<version>/<sourcedir_name>/<contents>
                          #   e.g.  .../backups/<version>/data/<contents>

# ----------
# Optional versioning strategy.
# Activate one and comment out the others.
# Or create other variations. Reading 'man date' may help and inspire you.
#
VERSIONDIR=""                  # no versioning, simply the target directory
#VERSIONDIR=$(date +'%F')       # one subdirectory for every date (YYYY-MM-DD)
#VERSIONDIR=$(date +'%u')       # one subdirectory for every day of week (1..7)
#VERSIONDIR=$(date +'%a')       # one subdirectory for every day of week (Mon..Sun, by locale)
#VERSIONDIR=$(date +'W%V/%u')   # one subdirectory per week (W01..W53) with sub-subdirectories per day of week (1..7)
#VERSIONDIR=$(date +'W%V/%a')   # one subdirectory per week (W01..W53) with sub-subdirectories per day of week (Mon..Sun, by locale)
#VERSIONDIR=$(date +'M%m/%d')   # one subdirectory per month (01..12) with sub-subdirectories per day (01..31)

# For some examples see the file README.md.

# ---------- Configuration - End

if [ ! -d ${SRCDIR} ] ; then
    echo "ERROR: ${SRCDIR} not found!"
    exit 1
fi

which lftp >/dev/null 2>&1
if [ $? -ne 0 ] ; then
    echo "Error: The program 'lftp' is required."
    echo "Please install it with e.g.:  sudo apt install lftp"
    exit 2
fi

# if there is a password given, prepend a colon for later use in lftp
[ -n "${TGTPW}" ] && TGTPW=":${TGTPW}"

LFTP_CFG="set net:timeout 5; set net:max-retries 1;"
LFTP_CMD="mirror --reverse --verbose=2"
LFTP_SRV=sftp://${TGTUSR}${TGTPW}@${TGTSRV}
LFTP_DIR=${TGTROOTDIR}
[ -n "${VERSIONDIR}" ] && LFTP_DIR="${LFTP_DIR}/${VERSIONDIR}"
[ "${TGTCREATEBASEDIR}" == "yes" ] && LFTP_DIR=${LFTP_DIR}/$(basename $SRCDIR)

echo "Copying '${SRCDIR}' to '${TGTUSR}@${TGTSRV}:${LFTP_DIR}'"

lftp -e "${LFTP_CFG}; lcd ${SRCDIR} && ${LFTP_CMD} -O ${LFTP_DIR} ; quit" ${LFTP_SRV}

# The possible final message from lftp, "To be removed: ..."
# denotes some older/other data in the target directory LFTP_DIR.
# That could be automatically deleted by lftp with the additional option '--delete'.
# BUT BE VERY CAREFULL or all other parallel backups are gone when done wrong!

