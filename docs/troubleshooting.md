# Диагностика

## Артефакты после Tab или completion

1. Откройте новый shell: `exec zsh`.
2. Убедитесь, что в `~/.zshrc.local` нет повторного `autoload -Uz compinit` и
   `compinit`: это уже делает Oh My Zsh.
3. По SSH shared-конфиг использует те же autosuggestions, syntax highlighting,
   Atuin, history search и `fzf-tab`, что и на Mac. После обновления выполните
   `exec zsh` или переподключитесь. Если проблема возникает только на сервере,
   временно закомментируйте `fzf-tab` в `configs/zsh/plugins.zsh` и повторите
   проверку.
4. Если линия всё равно портится, запустите чистый тест: `zsh -df`. Если в нём
   всё нормально, проблема именно в локальных дополнениях shell, а не в Ghostty.

## Ghostty через SSH

На удалённой машине выполните:

```bash
echo "$TERM"
infocmp "$TERM" >/dev/null && echo OK || echo MISSING
```

Этот репозиторий уже устанавливает в Ghostty `term = xterm-256color` и
`shell-integration = none`. Полностью перезапустите Ghostty, затем заново
подключитесь по SSH. Это осознанный compatibility-first режим для серверов.

## Команда не найдена на Ubuntu

```bash
command -v eza dust xh yq lazygit gh atuin
printf '%s\n' "$PATH"
```

## Atuin сообщает `GLIBC_2.39 not found`

Это означает, что готовый GNU-бинарник новее системной библиотеки Ubuntu 22.04
(`glibc 2.35`). Обновите репозиторий и повторно запустите `./install.sh`.
Установщик скачает официальный совместимый вариант Atuin в `~/.atuin/bin`; он
автоматически имеет приоритет над старым бинарником из `~/.cargo/bin`. Затем
выполните `exec zsh`.

## На Ubuntu 22.04 не найден `zsh-history-substring-search`

Это не ошибка установки: в некоторых зеркалах Jammy такого APT-пакета нет.
`./install.sh` автоматически скачает тот же плагин в Oh My Zsh и подключит его
как fallback. После установки выполните `exec zsh`; `↑` и `↓` снова будут искать
по набранному префиксу.

Cargo кладёт инструменты в `~/.cargo/bin`, а `yq`, lazygit и совместимые `fd`/
`bat` — в `~/.local/bin`. Оба пути добавлены в общий Zsh-конфиг.

## Вернуть прежний конфиг

Старые файлы находятся в `~/.dotfiles-backups/<дата-время>/`. Удалите только
конкретную ссылку и переместите нужный backup обратно. Не переносите старый
`.zshrc` целиком: перенесите личные exports/пути в `~/.zshrc.local`, чтобы не
загрузить Oh My Zsh и completion второй раз.
