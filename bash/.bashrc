# This is a simple bashrc stub which just sources other files.
if [ -d "$HOME/.bashrc.d" ]; then
    for rcfile in "$HOME/.bashrc.d/"*; do
        source "$rcfile"
    done
fi
