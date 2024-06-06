# Notion for Linux

This is a meta repo that contains scripts/stuff needed to build Notion for Linux

## Alternatives (based on this repo)

### Arch Linux

[notion-app-electron](https://aur.archlinux.org/packages/notion-app-electron)

### Gentoo

I provide an ebuild in [my overlay](https://github.com/jaredallard/overlay)

## How?

The electron sources are pulled out of the macOS dmg and then ran with a Linux version of Electron, yeah, it's that easy.

## Customizing

Modify `config.sh` before running `build.sh` or `makepkg -si`

```bash
NOTION_VERSION=x.x.x notion dmg to download
```

## Installing

Ensure you have the dependencies installed:

* 7zip (7zip on ubuntu)

Run `sudo ./build.sh [--no-compress]`

## Uninstalling

* Run `sudo ./uninstall.sh`

Or manually:

* Delete the application `rm -rf /opt/notion`
* Delete desktop entry `rm -r ~/.local/share/applications/Notion.desktop`
* Delete `rm /usr/bin/notion`

## License

MIT
