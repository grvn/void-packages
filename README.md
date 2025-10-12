# Void Linux Software Repository

This repo contains packages that I want but have not found in any of the [mirrors](https://xmirror.voidlinux.org/).

> *__NOTE__*: Should you really use random binaries of the internet???

> Your warranty is now void.<br>
> I am not responsible for bricked devices, failed installations, thermonuclear war,
> or you getting fired because the computer failed.<br>
> Please do some research if you have any concerns about the content of this repo. <br>
> If you point the finger at me for messing up your installation, I will laugh at you.

# How to use
```shell
printf "repository=https://github.com/grvn/void-packages/releases/latest/download/\n" > /etc/xbps.d/grvn-void-repository.conf
xbps-install -S
```

> *__WARNING__*: The key `9e:4d:55:e4:c2:98:1f:13:0c:ac:97:5b:68:66:9d:42.plist` may have been compromised and I will not continue using it.

> *__NOTE__*: First time running `xbps-install -S` you will be asked if you wish to import the repository key.
> For glibc x86_64 it will be [ee:04:bb:97:bf:cd:bb:73:6e:97:85:e6:a2:29:0a:b1.plist](./repo-keys/x86_64/ee:04:bb:97:bf:cd:bb:73:6e:97:85:e6:a2:29:0a:b1.plist).
> If you wish to script it
> ```shell
> cp ./repo-keys/x86_64/ee:04:bb:97:bf:cd:bb:73:6e:97:85:e6:a2:29:0a:b1.plist /var/db/xbps/keys/ee:04:bb:97:bf:cd:bb:73:6e:97:85:e6:a2:29:0a:b1.plist
> ```

# Available packages
| package | source | automatic update |
|:--------|:-------|:-----------------|
| brave-browser (stable) | https://www.brave.com/                            | :white_check_mark: |
| destilled-fonts        | <opinionized list of fonts I want>                | :x: |
| ly (TUI dm)            | https://github.com/fairyglade/ly                  | :white_check_mark: |
| obsidian.md            | https://obsidian.md/                              | :white_check_mark: |
| openshift-oc (oc cli)  | https://github.com/openshift/oc                   | :white_check_mark: |
| pexip-infinity-connect | https://www.pexip.com/                            | :x: |
| rebos                  | https://gitlab.com/Oglo12/rebos                   | :white_check_mark: |
| river-status           | https://github.com/grvn/river-status              | :white_check_mark: |
| vesktop                | https://vesktop.vencord.dev/                      | :white_check_mark: |
| wideriver              | https://github.com/alex-courtis/wideriver         | :white_check_mark: |
| zen-browser (stable)   | https://www.zen-browser.app/                      | :white_check_mark: |

# Archived packages
| package | source | reason |
|:--------|:-------|:-----------------|
| pet                    | https://github.com/knqyf263/pet                   | available in [upstream void-packages](https://github.com/void-linux/void-packages) |
| river-bedload          | https://git.sr.ht/~novakane/river-bedload         | available in [upstream void-packages](https://github.com/void-linux/void-packages) |
