# ciytools Helper Scripts

This repository provides a simple bootstrap script to install or update the [ciytools -scripts](https://github.com/ciybe/ciytools).

The bootstrap script will:

- Install `git` if it is not already installed
- Clone the helper scripts repository into `/opt/ciytools`
- Add `/opt/ciytools/scripts` to your `$PATH` (via `~/.bashrc`)
- Update the repo automatically on subsequent runs

---

## 🚀 Installation / Update

Run this single command on your Proxmox node:

```bash
bash -c "$(curl -fsSL https://ciybt.github.io/ciytools/ciytools-install.sh)"
