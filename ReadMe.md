# XWaydroid

<p align="left">
    <a href="https://github.com/Rikj000/XWaydroid/releases">
        <img src="https://img.shields.io/github/downloads/Rikj000/XWaydroid/total?label=Total%20Downloads&logo=github" alt="Total Releases Downloaded from GitHub">
    </a> <a href="https://github.com/Rikj000/XWaydroid/releases/latest">
        <img src="https://img.shields.io/github/v/release/Rikj000/XWaydroid?include_prereleases&label=Latest%20Release&logo=github" alt="Latest Official Release on GitHub">
    </a> <a href="https://github.com/Rikj000/XWaydroid/blob/master/LICENSE.md">
        <img src="https://img.shields.io/github/license/Rikj000/XWaydroid?label=License&logo=gnu" alt="GNU General Public License">
    </a> <a href="https://github.com/Rikj000/XWaydroid#xwaydroid">
        <img src="https://img.shields.io/badge/Docs-XWaydroid-blue?logo=libreoffice&logoColor=white" alt="The current place where you can find all XWaydroid Documentation!">
    </a><a href="https://www.iconomi.com/register?ref=zQQPK">
        <img src="https://img.shields.io/badge/Join-ICONOMI-blue?logo=bitcoin&logoColor=white" alt="ICONOMI - The world’s largest crypto strategy provider">
    </a> <a href="https://www.buymeacoffee.com/Rikj000">
        <img src="https://img.shields.io/badge/-Buy%20me%20a%20Coffee!-FFDD00?logo=buy-me-a-coffee&logoColor=black" alt="Buy me a Coffee as a way to sponsor this project!">
    </a>
</p>

XWaydroid, the Waydroid launcher tool to improve the user experience of KDE / X-Server users!

## Note-able Features
- Directly launch the full `waydroid` UI in a `wayland` session window
- Directly launch `waydroid` apps in a `wayland` session window
- Patch all your `waydroid.*.desktop` files to directly launch in a `wayland` session window through `xwaydroid`!

## Dependencies
XWaydroid requires the following dependencies to work properly,   
installation of these is out of the scope of this guide. 

- [Waydroid](https://github.com/waydroid/waydroid) *(Guide assumes `waydroid-container.service` has been enabled)*
- [KWin_Wayland](https://community.kde.org/KWin/Wayland)
- [ADB](https://developer.android.com/tools/adb)

## Installation
1. Download the latest [XWaydroid](https://github.com/Rikj000/XWaydroid/releases) release
2. Unzip it somewhere (e.g. `/home/<username>/Documents/XWaydroid/>`)
3. Create a symbolic link to `/usr/bin/xwaydroid`:
```bash
# Alter <username>!
sudo ln -s /home/<username>/Documents/XWaydroid/xwaydroid.sh /usr/bin/xwaydroid
```

## Updates
1. Download the latest [XWaydroid](https://github.com/Rikj000/XWaydroid/releases) release.
2. Unzip it to the previous installation location (default. `/home/<username>/Documents/XWaydroid/>`)

## Usage
```bash
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
```

## Notes
- Please be patient when starting the first `waydroid` app through `xwaydroid`.
    A black `kwin_wayland` window for a few minutes, before you see the LineageOS loading logo, is normal.
- If switching between `waydroid` apps through `xwaydroid`, it's recommended to leave the `kwin_wayland` window open.
    Closing / re-opening the `kwin_wayland` window leads to a "reboot" of the `waydroid` session which takes a while.
    Leaving the `kwin_wayland` window, leads to instant startup of new `waydroid` apps.
- Opening / using multiple `waydroid` apps through `xwaydroid` is supported, albeit through a single `kwin_wayland` window. 
- The default values of some optional-options,
    can be configured in the `Default Settings` section at the start of the `xwaydroid` script.
