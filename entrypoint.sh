#!/bin/bash
set -eu

SSHPATH="$HOME/.ssh"
mkdir "$SSHPATH"
echo "$SSH_PRIVATE_KEY" > "$SSHPATH/key"
echo "Host *
              PubkeyAcceptedKeyTypes +ssh-rsa
              KexAlgorithms +diffie-hellman-group1-sha1
              HostKeyAlgorithms +ssh-rsa" > "$SSHPATH/config"
chmod 400 "$SSHPATH/key"
chmod 400 "$SSHPATH/config"
SERVER_DEPLOY_STRING="$REMOTE_USER@$REMOTE_HOST:$TARGET_DIRECTORY"


file_path="$SSHPATH/known_hosts"

if test -f "$file_path"; then
    rm "$SSHPATH/known_hosts"
    echo "File deleted."
else
    echo "File does not exist."
fi

# Run Rsync synchronization
sh -c "rsync $ARGS -e 'ssh -v -i $SSHPATH/key -p $REMOTE_HOST_PORT' . $SERVER_DEPLOY_STRING"
