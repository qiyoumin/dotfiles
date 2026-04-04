# dotfiles

This repository manages shell and editor config with `GNU Stow`.

Only the required entry files are linked into `$HOME`:

- `~/.bashrc`
- `~/.gitconfig`
- `~/.vimrc`
- `~/.tmux.conf`

Platform-specific fragments stay inside this repository and are loaded by the
entry files. For example, WSL-specific Bash settings live in
`bash/.bashrc.d/wsl.bashrc`.

## Requirements

- `stow`

## Install

Apply the configuration:

```bash
./setup_all.sh
```

Preview changes without creating links:

```bash
./setup_all.sh --dry-run
```

The installer backs up existing entry files into a timestamped
`dotfile_bk_YYYYMMDDHHMMSS` directory before linking.

## Layout

- `bash/.bashrc`: main Bash entry point
- `bash/.bashrc.d/`: Bash fragments such as WSL-specific settings
- `git/.gitconfig`: Git config
- `tmux/.tmux.conf`: tmux config
- `vim/.vimrc` and `vim/.vim/`: Vim config
