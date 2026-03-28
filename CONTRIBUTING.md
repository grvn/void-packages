# 🤝 How to contribute

I'm really glad you're reading this, I'm doing the best with want I got, but help is always wanted.

Want a package added, or spotted something broken?

- **Package updates** are handled (mostly) automatically by the workflow — no need to bump versions manually
- **[Open an issue](https://github.com/grvn/void-packages/issues/new)** — request a new package or report a build failure
- **[Submit a PR](https://github.com/grvn/void-packages/pulls)** — add your own template following the existing structure and coding convention (one directory per package inside [srcpkgs](./srcpkgs/), containing a `template` file and if possible, a `update.sh` along side a `.template`)
  - If an `update.sh` is possible, please add it to [the workflow](./.github/workflows/update.yml)
