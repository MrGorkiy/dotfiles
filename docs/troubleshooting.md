# Диагностика

## Артефакты после Tab или completion

1. Откройте новый shell: `exec zsh`.
2. Убедитесь, что в `~/.zshrc.local` нет повторного `autoload -Uz compinit` и
   `compinit`: это уже делает Oh My Zsh.
3. Временно исключите `fzf-tab` из массива `plugins` в `configs/zsh/plugins.zsh`
   и снова запустите `exec zsh`, чтобы изолировать проблему.
4. Не добавляйте тяжёлые рамки или многострочный right prompt в P10K.

## Ghostty через SSH

На удалённой машине выполните:

```bash
echo "$TERM"
infocmp xterm-ghostty >/dev/null && echo OK || echo MISSING
```

Если terminfo отсутствует, диагностический тест — `TERM=xterm-256color ssh
host`. Если с ним артефакты исчезают, установите terminfo Ghostty на сервер;
не оставляйте подмену `TERM` постоянным решением без необходимости.

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
