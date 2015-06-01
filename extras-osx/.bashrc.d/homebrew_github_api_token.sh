if [ -f "$HOME/.github_token" ]; then
    export HOMEBREW_GITHUB_API_TOKEN=$(cat ~/.github_token)
fi
