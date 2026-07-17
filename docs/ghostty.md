# Ghostty и prompt

Конфиг Ghostty применяется только на macOS. Он использует Catppuccin Mocha,
MesloLGS Nerd Font Mono 15pt, умеренную прозрачность/blur, block-cursor и
shell integration. После изменения конфигурации нажмите `Cmd+Shift+,` или
полностью перезапустите Ghostty.

Powerlevel10k намеренно минималистичен: одна строка, без рамок и без правого
status-блока. Локально он показывает каталог, Git и короткий prompt; по SSH
добавляет host. Ошибки отмечаются красным prompt-символом, а не широкой правой
панелью. Такая схема устойчивее при `Tab`, SSH и длинных командах.

```bash
ghostty +version
ghostty +list-fonts | rg -i 'Meslo.*Nerd'
```

Если icon-глифы или ширина prompt выглядят неверно, проверьте, что Ghostty
действительно использует именно Meslo Nerd Font Mono, а не fallback-шрифт.

## Первый SSH-вход на Linux

Ghostty передаёт `TERM=xterm-ghostty`. На сервере должен быть соответствующий
terminfo; иначе `less`, `bat`, completion и перерисовка строк могут работать
некорректно. Один раз на Mac скопируйте готовую запись Ghostty на сервер:

```bash
ssh mrgorkiy 'mkdir -p ~/.terminfo/78'
scp /Applications/Ghostty.app/Contents/Resources/terminfo/78/xterm-ghostty \
  mrgorkiy:~/.terminfo/78/xterm-ghostty
ssh mrgorkiy 'TERM=xterm-ghostty infocmp xterm-ghostty >/dev/null && echo OK'
```

Замените `mrgorkiy` на нужный SSH-host alias. Не подменяйте `TERM` постоянно:
правильный terminfo сохраняет возможности Ghostty на удалённой машине.
