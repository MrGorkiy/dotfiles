# Диагностика

## Артефакты после Tab или completion

1. Откройте новый shell: `exec zsh`.
2. Убедитесь, что в `~/.zshrc.local` нет повторного `autoload -Uz compinit` и
   `compinit`: это уже делает Oh My Zsh.
3. По SSH shared-конфиг отключает P10K, `fzf-tab`, autosuggestions и syntax
   highlighting; остаётся обычное completion Zsh. После обновления выполните
   `exec zsh` или переподключитесь.
4. Если линия всё равно портится, запустите чистый тест: `zsh -df`. Если в нём
   всё нормально, проблема именно в локальных дополнениях shell, а не в Ghostty.

## Ghostty через SSH

На удалённой машине выполните:

```bash
echo "$TERM"
infocmp xterm-ghostty >/dev/null && echo OK || echo MISSING
```

Этот репозиторий уже устанавливает в Ghostty `term = xterm-256color` и
`shell-integration = none`. Полностью перезапустите Ghostty, затем заново
подключитесь по SSH. Это осознанный compatibility-first режим для серверов.

## Команда не найдена на Ubuntu

```bash
command -v eza dust xh yq lazygit gh atuin
printf '%s\n' "$PATH"
```

Cargo кладёт инструменты в `~/.cargo/bin`, а `yq`, lazygit и совместимые `fd`/
`bat` — в `~/.local/bin`. Оба пути добавлены в общий Zsh-конфиг.

## Вернуть прежний конфиг

Старые файлы находятся в `~/.dotfiles-backups/<дата-время>/`. Удалите только
конкретную ссылку и переместите нужный backup обратно. Не переносите старый
`.zshrc` целиком: перенесите личные exports/пути в `~/.zshrc.local`, чтобы не
загрузить Oh My Zsh и completion второй раз.
