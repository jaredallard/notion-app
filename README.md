# Notion for Linux

This is a meta repo that contains scripts / stuff needed to build Notion for Linux

## Alternatives

If you're on Arch Linux, there is a package in the AUR called `notion-app`.

## How?

The electron sources are pulled out of the Mac OSX dmg and then ran with a Linux version of Electron, yeah, it's that easy.

## Building

Ensure you have the dependencies installed:

 * 7zip (p7zip-full on ubuntu)
 * dmg2img

Run `./build.sh [--no-compress]`

## Customizing

Modify `config.sh` before running `build.sh` or `makepkg -si`

```bash
ELECTRON_VERSION=x.x.x electron version to use
NOTION_VERSION=x.x.x notion dmg to download
```

## Installing

After running the [Build](#building) step:

Extract the built tar file into `/opt/notion` and then cp the `notion` shell script to `/usr/bin/notion`

## License

MIT
