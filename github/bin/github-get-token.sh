#!/bin/sh

die () {
    echo "$*" >&2
    exit 1
}

[ -e "$HOME/.github_token" ] &&
    die 'Token already exists! If you want a new one, delete the old one.'

read -s -p "$USER's GitHub password: " PASS
echo
read -p "$USER's OTP (if 2fa is required): " OTP

# This pretty horrible for a number of reasons!
TOKEN=$(curl 'https://api.github.com/authorizations' \
    --silent --fail --user "$USER:$PASS" \
    --header "X-GitHub-OTP: $OTP" \
    --data '{"note":"github-get-token.sh @ '"$HOSTNAME"'"}' |
    grep '"token":' |
    sed 's/.*"token": *"\([^"]*\)".*/\1/') ||
    die 'Failed to get a token.'

curl 'https://api.github.com/user' \
    --silent --fail --user "$USER:$TOKEN" &&
    echo "$TOKEN" > "$HOME/.github_token" ||
    die 'Failed to get a valid token.'
