# dotfiles

This repository manages shell and editor config with `GNU Stow`.

Only the required entry files are linked into `$HOME`:

- `~/.bashrc`
- `~/.zshrc`
- `~/.gitconfig`
- `~/.vimrc`
- `~/.tmux.conf`

Platform-specific fragments stay inside this repository and are loaded by the
entry files. For example, WSL-specific Bash settings live in
`bash/.bashrc.d/wsl.bashrc`.

Machine-local overrides are not stored in this repository. Instead, the managed
entry files load optional local files from `$HOME` when present:

- `~/.bashrc.local`
- `~/.zshrc.local`
- `~/.gitconfig.local`

Example templates for those local files live in:

- `bash/.bashrc.local.example`
- `zsh/.zshrc.local.example`
- `git/.gitconfig.local.example`

## Requirements

- `stow`

## Install

Apply the configuration:

```bash
./setup_all.sh
```

The installer auto-detects your default login shell and installs either the
`bash` or `zsh` package together with the shared `git`, `vim`, and `tmux`
packages.

Override shell selection explicitly when needed:

```bash
./setup_all.sh --shell bash
./setup_all.sh --shell zsh
```

The installer now runs in stages:

1. dependency checks
2. backup of managed entry files that would conflict
3. `stow` preflight
4. apply

If any preflight or apply step fails after backups are taken, the script automatically
removes links it created in this run and restores the original files.

Preview changes without creating links:

```bash
./setup_all.sh --dry-run
./setup_all.sh --dry-run --shell zsh
```

Run checks only:

```bash
./setup_all.sh --check
```

The installer backs up existing entry files into a timestamped
`dotfile_bk_YYYYMMDDHHMMSS` directory before linking.

## Verification

`./setup_all.sh --check` verifies:

- required commands such as `stow`
- expected managed directories in this repository
- whether each managed package can pass a `stow -n` preflight against `$HOME`

Use this before applying changes on a new machine or after restructuring the
repository.

## Rollback

When `./setup_all.sh` is running, any failure after the backup stage
triggers an automatic rollback for that run:

- links created by the failed run are removed
- backed-up entry files are restored to their original locations

Backups remain in the timestamped `dotfile_bk_*` directory for manual recovery
if you want to inspect or restore them yourself later.

## Layout

- `bash/.bashrc`: main Bash entry point
- `bash/.bashrc.d/`: Bash fragments such as WSL-specific settings
- `zsh/.zshrc`: main Zsh entry point
- `zsh/.zshrc.d/`: Zsh fragments such as WSL-specific settings
- `git/.gitconfig`: Git config
- `tmux/.tmux.conf`: tmux config
- `vim/.vimrc` and `vim/.vim/`: Vim config
