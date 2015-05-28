#!/bin/sh

die () {
    echo "fatal: $* for you :'(" >&2
    exit 1
}

warn () {
    echo "warning: $*" >&2
}

require () {
    pkg=$1

    # First see if the thing is already present.
    [ -z "$FORCE_INSTALL" ] && {
        # Check if it's in our PATH.
        which "$pkg" && return 0

        # Just OSX things.
        if [ "$(uname)" = "Darwin" ]; then
            # Check for brew.
            if which brew; then
                # Check if brew has it.
                brew list "$pkg" && return 0
                # Check if we have brew-cask.
                if brew list brew-cask; then
                    # Check if we have a cask for it.
                    brew cask list "$pkg" && return 0
                fi
            fi
        fi
    } >/dev/null 2>&1

    # Check to see if we know how to get the thing.
    # First, try a platform specific way.
    pkg_command_name="install_$(uname)_$pkg"
    eval "pkg_command=\$$pkg_command_name"
    if [ -z "$pkg_command" ]; then
        # Otherwise we'll try a generic way.
        pkg_command_name="install_$pkg"
        eval "pkg_command=\$$pkg_command_name"
    fi

    if [ -z "$pkg_command" ]; then
        warn "I don't know how to install '$pkg' on '$(uname)'. You're on your own."
        return 1
    fi

    # We know how, so let's get the thing.
    (eval "set -e; $pkg_command") || die "I couldn't get $pkg"
}

install_Darwin_brew='
    require curl
    require ruby

    brew_url="https://raw.githubusercontent.com/Homebrew/install/master/install"
    curl --fail --location "$brew_url" | ruby -

    brew update
    brew doctor

    # TODO: Figure out why I want these
    for tap in completitions science versions; do
        brew tap homebrew/$tap
    done

    brew prune
'

install_Darwin_brew_cask='
    require brew
    brew install caskroom/cask/brew-cask
'

install_Darwin_iterm2='
    require brew_cask
    brew cask install iterm2
'

install_Darwin_pstree='
    require brew
    brew install pstree
'

install_Darwin_s3cmd='
    require brew
    brew install s3cmd
'

install_Darwin_stow='
    require brew
    brew install stow
'

install_Darwin_tree='
    require brew
    brew install tree
'

# These are meta packages
install_Darwin_meta_platform_extras='
    require iterm2
'

install_meta_dotfiles='
    if [ ! -d "$HOME/dotfiles" ]; then
        if [ -e "$HOME/dotfiles" ]; then
            die "Woah nelly! I need $HOME/dotfiles to not be there right now. Failed to get your dotfiles"
        fi

        # Try something dangerous!
        require git
        warn "I am going to try and get $USER/dotfiles from github!"
        cd "$HOME" && git clone "git://github.com/$USER/dotfiles"
    fi
'

install_meta_vim='
    require vim
    require meta_dotfiles
    require stow

    cd "$HOME/dotfiles"
    stow vim
'

# Stuff I always want
install_meta_default='
    require meta_platform_extras
    require meta_vim
    require pstree
    require s3cmd
    require screen
    require tree
'

main () {
    if [ $# -eq 0 ]; then
        set -- meta_default
    fi

    while [ $# -gt 0 ]; do
       require $1; shift
    done

    echo "All done for you."
}

# Let's do it.
main
