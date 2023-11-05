#!/bin/bash

# region Default Settings

WAYDROID_LAUNCH_APP="";
WAYDROID_BIN="waydroid";
XWAYDROID_BIN="xwaydroid";
WAYLAND_WINDOW_BIN="kwin_wayland";
WAYLAND_WINDOW_WIDTH=3440
WAYLAND_WINDOW_HEIGHT=1340

# endregion Default Settings


# region Helpers

usage() {
    cat << EOF

    Usage:
        xwaydroid [options]

    Example:
        xwaydroid --app=com.android.calculator2

    Optional-Arguments:
    | Shorthand             | Full notation                         | Description                                                       |
    | --------------------- | ------------------------------------- | ----------------------------------------------------------------- |
    | -h                    | --help                                | Show this help.                                                   |
    | -v                    | --version                             | Show the currently installed XWaydroid version number             |
    | -a=<app-name>         | --app=<app-name>                      | Name of the Waydroid app to open, defaults to: '' (show-full-ui)  |
    | -l                    | --list                                | Lists all names of installed app. (Waydroid must be running)      |
    | -pdf                  | --patch-desktop-files                 | Patches all the                                                   |
    |                       |                                       | "/home/<username>/.local/share/applications/waydroid.*.desktop"   |
    |                       |                                       | files, to automatically launch through XWaydroid.                 |
    | -wb=<binary-path>     | --waydroid-bin=<binary-path>          | Path to the Waydroid binary, defaults to: 'waydroid'              |
    | -wwb=<binary-path>    | --wayland-window-bin=<binary-path>    | Path to the Wayland window, defaults to: 'kwin_wayland'           |
    |                       |                                       | Others not yet supported.                                         |
    | -www=<width>          | --wayland-window-width=<width>        | Pixel width of the Wayland window, defaults to: 3440              |
    | -wwh=<height>         | --wayland-window-height=<height>      | Pixel height of the Wayland window, defaults to: 1340             |

EOF
    exit 0
}

WAYLAND_WINDOW_WAS_OPEN=false;
wayland_window_running() {
    if pgrep -x "$WAYLAND_WINDOW_BIN" >/dev/null
    then
        log "Service '$WAYLAND_WINDOW_BIN' is already running...";
        WAYLAND_WINDOW_WAS_OPEN=true;
    else
        log "Service '$WAYLAND_WINDOW_BIN' starting up...";
        $WAYLAND_WINDOW_BIN --width $WAYLAND_WINDOW_WIDTH --height $WAYLAND_WINDOW_HEIGHT &
        log_success "Service '$WAYLAND_WINDOW_BIN' started up!";
    fi
}

waydroid_running() {
    if [[ $WAYLAND_WINDOW_WAS_OPEN = true ]] && [[ $(pgrep -f "$WAYDROID_BIN show-full-ui") != "" ]]
    then
        log "Service '$WAYDROID_BIN' is already running...";
    else
        log "Service '$WAYDROID_BIN' starting up...";
        $WAYDROID_BIN session stop;

        while read -r line; do
            if [[ $line == *"Established ADB connection to Waydroid device at"* ]]; then
                log_success "Service '$WAYDROID_BIN' started up!";
                break
            fi
        done < <($WAYDROID_BIN show-full-ui 2>&1)
    fi
}

waydroid_launch_app() {
    if [ "$WAYDROID_LAUNCH_APP" != "" ]; then
        WAYDROID_LAUNCH_ACTIVITY=$(
            adb shell cmd package resolve-activity -c android.intent.category.LAUNCHER "$WAYDROID_LAUNCH_APP" | \
            sed -n '/name=/s/^.*name=//p');

        log "App '$WAYDROID_LAUNCH_APP' with launch activity '$WAYDROID_LAUNCH_ACTIVITY' starting up...";
        adb shell am start "$WAYDROID_LAUNCH_APP"/"$WAYDROID_LAUNCH_ACTIVITY" >/dev/null;
        log_success "App '$WAYDROID_LAUNCH_APP' with launch activity '$WAYDROID_LAUNCH_ACTIVITY' started up!";
    fi
}

waydroid_list_apps() { $WAYDROID_BIN app list | grep packageName | cut -c 14-; }

xwaydroid_patch_desktop_files() {
    DESKTOP_FILES_PATH="/home/$(whoami)/.local/share/applications";

    SEARCH_STRING="Exec=waydroid app launch ";
    REPLACE_STRING="Exec=${XWAYDROID_BIN} --app=";
    sed -i "/^${SEARCH_STRING}/s#${SEARCH_STRING}#${REPLACE_STRING}#" "$DESKTOP_FILES_PATH/waydroid."*".desktop";

    SEARCH_STRING="Exec=waydroid show-full-ui";
    REPLACE_STRING="Exec=${XWAYDROID_BIN}";
    sed -i "/^${SEARCH_STRING}/s#${SEARCH_STRING}#${REPLACE_STRING}#" "$DESKTOP_FILES_PATH/Waydroid.desktop";

    log_success "Patched 'waydroid.*.desktop' files under '$DESKTOP_FILES_PATH/' to launch with XWaydroid!"
}

# ANSI text coloring
GREEN='\033[0;32m';
RED='\033[0;31m';
END='\033[m';

log() { echo "[$(date +"%H:%M:%S")] $1"; }

log_success() { echo -e "${GREEN}$(log "$1")${END}"; }

log_error() { echo -e "${RED}$(log "$1")${END}"; }

# endregion Helpers


# region Process Parameters

# Loop through arguments and process them
for arg in "$@"
do
    case $arg in
        -a=*|--app=*)
        WAYDROID_LAUNCH_APP="${arg#*=}";
        shift
        ;;
        -wb=*|--waydroid-bin=*)
        WAYDROID_BIN="${arg#*=}";
        shift
        ;;
        -wwb=*|--waydroid-window-bin=*)
        WAYLAND_WINDOW_BIN="${arg#*=}";
        shift
        ;;
        -www=*|--wayland-window-width=*)
        WAYLAND_WINDOW_WIDTH=${arg#*=};
        shift
        ;;
        -wwh=*|--wayland-window-height=*)
        WAYLAND_WINDOW_HEIGHT=${arg#*=};
        shift
        ;;
        -l|--list)
        waydroid_list_apps;
        exit;
        shift
        ;;
        -pdf|--patch-desktop-files)
        xwaydroid_patch_desktop_files;
        exit;
        shift
        ;;
        -h|--help)
        usage
        shift
        ;;
        -v|--version)
        echo "v1.0.0"
        exit;
        shift
        ;;
        *)
        log_error "  🙉  Illegal argument(s) used!";
        echo "";
        log "Please see the 'xwaydroid --help' output below for the correct usage:";
        usage;
        exit;
        ;;
    esac
done

# endregion Process Parameters


# region Main Script

wayland_window_running; # 1. Ensure the Wayland window is running, open it if not
waydroid_running;       # 2. Ensure the Waydroid main UI is running, open it if not
waydroid_launch_app;    # 3. Launch the Waydroid app, if any have been provided

# endregion Main Script
