#!/usr/bin/env bash
{
    # ARCANIST_MANAGER_HOME="."
    do_install() {
        local INSTALL_DIR
        INSTALL_DIR=${ARCANIST_MANAGER_HOME:-$HOME/.arcanist-manager}

        # Make an absolute path to the INSTALL_DIR
        INSTALL_DIR=`cd $INSTALL_DIR; pwd`

        echo "Install directory set to $INSTALL_DIR"

        if [ -d "$INSTALL_DIR/libphutil" ]; then
            echo "Pulling latest libphutil"
            command git -C "$INSTALL_DIR/libphutil" pull --quiet
        else
            echo "Cloning libphutil"
            command git clone https://github.com/phacility/libphutil.git
        fi

        if [ -d "$INSTALL_DIR/arcanist" ]; then
            echo "Pulling latest arcanist"
            command git -C  "$INSTALL_DIR/arcanist" pull --quiet
        else
            echo "Cloning arcanist"
            command git clone https://github.com/phacility/arcanist.git
        fi

        if [ -d "$INSTALL_DIR/arcanist-extensions" ]; then
            echo "Pulling latest arcanist-extensions"
            command git -C  "$INSTALL_DIR/arcanist-extensions" pull --quiet
        else
            echo "Cloning arcanist-extensions"
            command git clone https://github.com/tagview/arcanist-extensions.git
        fi

        command ln -sf "$INSTALL_DIR/arcanist-extensions" "$INSTALL_DIR/arcanist/externals/includes/arcanist-extensions"
    }
    do_install
}
