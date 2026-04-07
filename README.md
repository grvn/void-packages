<div align="center">

<img src="https://voidlinux.org/assets/img/void_bg.png" width="75" />

<h1>Custom XBPS Void Linux Software Repository</h1>

<p>A (sometimes) self-updating, signed package repository for Void Linux containing packages that I want but have not found in any of the [mirrors](https://xmirror.voidlinux.org/).</p>

[![Build](https://img.shields.io/github/actions/workflow/status/grvn/void-packages/build.yml?style=for-the-badge&label=BUILD&logo=githubactions&logoColor=white)](https://github.com/grvn/void-packages/actions)
&nbsp;
[![Updates](https://img.shields.io/github/actions/workflow/status/grvn/void-packages/update.yml?style=for-the-badge&label=AUTO-UPDATE&logo=github&logoColor=white)](https://github.com/grvn/void-packages/actions)


![GitHub](https://img.shields.io/github/license/grvn/void-packages?style=for-the-badge&label=License&color=purple&logo=gitbook)
![GitHub contributors](https://img.shields.io/github/contributors/grvn/void-packages?style=for-the-badge&color=purple&logo=github&label=Contributors)
![GitHub release (with filter)](https://img.shields.io/github/v/release/grvn/void-packages?style=for-the-badge&logo=github&label=Release&color=purple)
![GitHub issues](https://img.shields.io/github/issues-raw/grvn/void-packages?style=for-the-badge&label=Open%20Issues&logo=github&color=purple)
![GitHub closed issues](https://img.shields.io/github/issues-closed-raw/grvn/void-packages?style=for-the-badge&label=Closed%20Issues&logo=github&color=purple)
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/grvn/void-packages/main?style=for-the-badge&label=Last%20Commit&logo=github&color=purple)

<p><sup>Packages built daily · Indexed and signed automatically</sup></p>

</div>

---

## Disclaimer

> *__NOTE__*: Should you really use random binaries of the internet???<br/>
> Your warranty is now void.<br>
> I am not responsible for bricked devices, failed installations, thermonuclear war,
> or you getting fired because the computer failed.<br>
> Please do some research if you have any concerns about the content of this repo. <br>
> If you point the finger at me for messing up your installation, I will laugh at you.

## Notice

> *__WARNING__*: The key `9e:4d:55:e4:c2:98:1f:13:0c:ac:97:5b:68:66:9d:42.plist` may have been compromised and I will not continue using it.

## ⚡ How to use

### ① Add the repository
```shell
printf "repository=https://github.com/grvn/void-packages/releases/latest/download/\n" > /etc/xbps.d/grvn-void-repository.conf
```

### ② Sync and trust the signing key

```shell
xbps-install -S
```

> *__NOTE__*: First time running `xbps-install -S` you will be asked if you wish to import the repository key.
> For glibc x86_64 it will be [ee:04:bb:97:bf:cd:bb:73:6e:97:85:e6:a2:29:0a:b1.plist](./repo-keys/x86_64/ee:04:bb:97:bf:cd:bb:73:6e:97:85:e6:a2:29:0a:b1.plist).<br/><br/>
> **If you wish to script it**
> ```shell
> cp ./repo-keys/x86_64/ee:04:bb:97:bf:cd:bb:73:6e:97:85:e6:a2:29:0a:b1.plist /var/db/xbps/keys/ee:04:bb:97:bf:cd:bb:73:6e:97:85:e6:a2:29:0a:b1.plist
> ```

### ③ Repo is ready to use

#### 🔄 Updates?

Once the repo is added, package updates will come automatically with:
```shell
xbps-install -Su
```

## 📦 Available packages
| package | source | automatic update |
|:--------|:-------|:-----------------|
| `brave-browser` (stable) | https://www.brave.com/                            | :white_check_mark: |
| `destilled-fonts`        | <opinionized list of fonts I want>                | :x: |
| `dgop`                   | https://github.com/AvengeMedia/dgop               | :white_check_mark: |
| `ly` (TUI dm)            | https://github.com/fairyglade/ly                  | :x: [bug #7](https://github.com/grvn/void-packages/issues/7) |
| `obsidian`.md            | https://obsidian.md/                              | :white_check_mark: |
| `openshift-oc` (oc cli)  | https://github.com/openshift/oc                   | :white_check_mark: |
| `pexip-infinity-connect` | https://www.pexip.com/                            | :x: |
| `rebos`                  | https://gitlab.com/Oglo12/rebos                   | :white_check_mark: |
| `river-status`           | https://github.com/grvn/river-status              | :white_check_mark: |
| `vesktop`                | https://vesktop.vencord.dev/                      | :white_check_mark: |
| `wideriver`              | https://github.com/alex-courtis/wideriver         | :white_check_mark: |
| `zen-browser` (stable)   | https://www.zen-browser.app/                      | :white_check_mark: |

## 📦 Archived packages
| package | source | reason |
|:--------|:-------|:-----------------|
| `pet`                    | https://github.com/knqyf263/pet                   | available in [upstream void-packages](https://github.com/void-linux/void-packages) |
| `river-bedload`          | https://git.sr.ht/~novakane/river-bedload         | available in [upstream void-packages](https://github.com/void-linux/void-packages) |

## 🛠 Troubleshooting

<details>
<summary><b>Key import failed or was declined</b></summary>
<br />
Try the scripted version, <b>make sure you run it the root of this repository</b>

```
cp ./repo-keys/x86_64/ee:04:bb:97:bf:cd:bb:73:6e:97:85:e6:a2:29:0a:b1.plist /var/db/xbps/keys/ee:04:bb:97:bf:cd:bb:73:6e:97:85:e6:a2:29:0a:b1.plist
```
</details>

<details>
<summary><b>Repository not found</b></summary>
<br />
Verify <code>/etc/xbps.d/grvn-void-repository.conf</code> contains exactly:

```
repository=https://github.com/grvn/void-packages/releases/latest/download/
```
</details>
