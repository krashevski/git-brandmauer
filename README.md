# git-security

A set of scripts for secure Git management and network access control when working with repositories.

## Description

git-security helps:

Check network status.

Enable or disable the network, change the password if necessary in emergency mode.

Log actions related to Git and network security.

## Network security operational scripts

- `bin/panic.sh` — manages enabling and disabling the network, as well as changing passwords for panic mode (emergency shutdown).
- `bin/network-pause.sh` — central network pause controller.
- `bin/net-status.sh` — network status.
- `bin/burn-zip-archives.sh` — burning ZIP archives to CD/DVD.
- `bin/menu.sh` — GIT-SECURITY management menu.

## Git-brandmauer Scripts

- `chesk.sh` -
- `common.sh` - mode detection script
- `git-brandmauer-mode` - mode switching for the current repository
= `install.sh` - production Installer (hooks-only)
- `menu.sh` - git-brandmauer interactive menu (per-repo)
- `uninstall.sh` - git-brandmauer uninstall script
- `hooks/pre-fetch` - manual configuration
- `hooks/pre-hook` - hook trigger template for the git command
- `hooks/pre-merge-commit` - git merge hook trigger
- `hooks/pre-push` - git push hook trigger
- `hook/pre-rebase` - git rebase hook trigger
- `state/mode` - state data

## Dependencies

`git-security` uses shared functions from the [`shared-lib`](https://github.com/krashevski/shared-lib) library.

For the project to work, `shared-lib` must be included in the `lib/shared-lib` directory.

### Installing `shared-lib` via a submodule

If you are cloning the project for the first time:

```bash
git clone --recurse-submodules https://github.com/krashevski/git-security
```

## Installing git-security

1. Clone the repository:

```bash
git clone https://github.com/krashevski/git_security
```

2. Change to the project directory:
```bash
cd git-security
```

3. Grant execute permissions to the scripts:
```bash
chmod +x *.sh
```

## Usage

Run the main network security script:
```bash
./net-security/bin/menu.sh
```
Logs are created in the ./logs directory.

Run the firewall installation script:
```bash
./git-brandmauer/install.sh
```

Run the firewall management script:
```bash
././git-brandmauer/menu.sh
```

## Notes

* The scripts were tested in a home environment (~/.scripts/git_security).

* Can also be used in test mode by changing the log paths and status.

## License

MIT

## Author

Vladislav Krashevsky, ChatGPT support