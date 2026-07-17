# Dotfiles

Переносимая терминальная среда для macOS и Ubuntu: Zsh, Powerlevel10k, tmux,
Ghostty, Git и современные CLI-инструменты. Конфиги улучшают интерактивную
работу, но не подменяют стандартные команды в скриптах.

## Что входит

- Shell: Zsh, Oh My Zsh, Powerlevel10k, `fzf-tab`, autosuggestions, syntax
  highlighting, history substring search и Atuin.
- Навигация и файлы: `fzf`, `zoxide`, `eza`, `bat`, `fd`, `rg`, `dust`, `ncdu`.
- Разработка: `xh`, `jq`, `yq`, `hyperfine`, `watchexec`.
- Git: Git, Delta, lazygit и GitHub CLI.
- Система: tmux, btop, bottom, lnav, tldr и procs.

Ghostty и Meslo Nerd Font устанавливаются только на macOS. Все остальные
настройки рассчитаны и на Ubuntu.

## Установка

Клонируйте репозиторий в постоянное место и запустите установщик:

```bash
git clone <ваш-remote> ~/Development/dotfiles
cd ~/Development/dotfiles
./install.sh
```

`bootstrap.sh` — обычная точка первого запуска, полностью эквивалентная
`install.sh` и принимающая те же параметры.

```bash
./install.sh --dry-run       # показать изменения без записи на диск
./install.sh --link-only     # только безопасно подключить конфиги
./install.sh --skip-ghostty  # macOS: не устанавливать Ghostty и шрифт
```

Установщик определяет macOS/Ubuntu, устанавливает согласованные пакеты,
скачивает готовые бинарники Rust CLI без локальной компиляции, устанавливает
shell-плагины и создаёт симлинки. Перед заменой каждого уже
существующего файла он переносит его в `~/.dotfiles-backups/<дата-время>/`.
Он не меняет login shell, не задаёт Git name/email и ничего не отправляет в
remote.

## Что связывается

```text
~/.zshrc                         -> ~/.config/dotfiles/configs/zsh/.zshrc
~/.p10k.zsh                      -> ~/.config/dotfiles/configs/p10k/.p10k.zsh
~/.tmux.conf                     -> ~/.config/dotfiles/configs/tmux/.tmux.conf
~/.config/atuin/config.toml      -> ~/.config/dotfiles/configs/atuin/config.toml
~/.config/bat/config             -> ~/.config/dotfiles/configs/bat/config
~/.config/ghostty/config         -> ~/.config/dotfiles/configs/ghostty/config (macOS)
~/.config/dotfiles               -> этот репозиторий
```

Глобальный `~/.gitconfig` остаётся вашим: установщик добавляет в него только
`include.path` с общими настройками Delta/Git. Личные пути, токены, SDK и
рабочие функции храните в `~/.zshrc.local`; он намеренно не попадает в Git.

Ссылка `config -> configs` оставлена как временная совместимость со ссылками,
созданными ранней версией репозитория. Новые пути используют только `configs/`.

## Структура

```text
bootstrap.sh       совместимая точка первого запуска
install.sh         кроссплатформенная установка
configs/           версионируемые конфиги
  zsh/              .zshrc и независимые zsh-модули
  ghostty/ tmux/ git/ p10k/ atuin/ bat/
scripts/           установка пакетов, плагинов и симлинков
bin/               небольшие переносимые команды в PATH
docs/              справка и инструкции
config -> configs  временная обратная совместимость
```

## После установки

```bash
exec zsh
th
zoxide query "$HOME" || true
tmux
git config --show-origin --get core.pager
```

Полностью закройте и снова откройте Ghostty после первой установки. На macOS
`Cmd+Shift+,` перечитывает его конфиг.

## Документация

- [Шпаргалка команд](docs/cheatsheet.md) — таблица, примеры и сценарии; её же
  открывает команда `th`.
- [Aliases и собственные команды](docs/aliases.md)
- [tmux](docs/tmux.md)
- [Ghostty и prompt](docs/ghostty.md)
- [Диагностика](docs/troubleshooting.md)

## Проверка репозитория

```bash
bash -n install.sh bootstrap.sh scripts/*.sh bin/*
zsh -n configs/zsh/.zshrc configs/zsh/*.zsh configs/p10k/.p10k.zsh
tmux -f configs/tmux/.tmux.conf start-server
git config --file configs/git/gitconfig --list
```

Обновления делайте осознанно: просмотрите `git diff`, затем повторно выполните
`./install.sh`. Git-коммиты и push остаются ручными действиями.
