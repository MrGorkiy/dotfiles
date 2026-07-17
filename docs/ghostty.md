# Ghostty и prompt

Конфиг Ghostty применяется только на macOS. Он использует Catppuccin Mocha,
MesloLGS Nerd Font Mono 15pt, умеренную прозрачность/blur, block-cursor и
shell integration. После изменения конфигурации нажмите `Cmd+Shift+,` или
полностью перезапустите Ghostty.

Powerlevel10k намеренно минималистичен: две строки, без рамок, compact right
prompt и transient prompt. Такая схема заметно устойчивее при `Tab`, SSH и
длинных командах, чем декоративные рамки и крупный right prompt.

```bash
ghostty +version
ghostty +list-fonts | rg -i 'Meslo.*Nerd'
```

Если icon-глифы или ширина prompt выглядят неверно, проверьте, что Ghostty
действительно использует именно Meslo Nerd Font Mono, а не fallback-шрифт.
