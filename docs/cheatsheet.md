# Шпаргалка терминала

Открыть из терминала: `th`. Редактировать: `the`. `th` использует Glow для
нормального рендеринга Markdown-таблиц и ссылок. Команды ниже рассчитаны на
macOS и Ubuntu после `./install.sh`. Обычные `grep`, `find`, `du`, `ps`, `top`,
`curl` и `git` не заменяются: они остаются безопасным выбором для скриптов и
инструкций из документации.

Для отдельных тем см. [aliases](aliases.md), [tmux](tmux.md),
[Ghostty и prompt](ghostty.md) и [диагностику](troubleshooting.md).

## Быстрая таблица

| Команда / alias | Оригинал или аналог | Коротко |
|---|---|---|
| `ls`, `la`, `ll`, `lt` | `ls` | Список файлов через eza, с Git-статусом и иконками |
| `cat` | `cat` | Просмотр через bat с подсветкой |
| `fd` | `find` | Быстрый поиск файлов |
| `rg` | `grep` | Быстрый поиск текста в проекте |
| `z`, `zi` | `cd` | Переход в часто используемые каталоги |
| `fzf` | ручной выбор | Интерактивный fuzzy-поиск |
| `dust` | `du` | Быстрый обзор размеров каталогов |
| `ncdu` | `du` | Интерактивный анализ диска |
| `xh` | `curl` / HTTPie | Читаемые HTTP-запросы |
| `jq` | — | Фильтрация и преобразование JSON |
| `yq` | — | Чтение и изменение YAML |
| `hyperfine` | `time` | Сравнение времени выполнения команд |
| `watchexec` | ручной перезапуск | Запускает команду после изменений |
| `gs`, `gd`, `gds`, `gl` | Git | Короткие ежедневные Git-команды |
| `lg` | Git GUI | lazygit: staging, commit, rebase, stash |
| `delta` | Git pager | Наглядные diff и конфликты |
| `gh` | GitHub web UI | PR, issues, workflow из терминала |
| `bp`, `bt` | `top` | btop / bottom: мониторинг |
| `procs` | `ps` | Поиск и просмотр процессов |
| `lnav` | `less` для логов | Логи, timestamps, фильтры |
| `tmux` | — | Переживающие SSH сессии |
| `atuin` | shell history | Полнотекстовая история команд |
| `tldr` | `man` | Короткие практические примеры |
| `th` / `the` | — | Открыть / редактировать эту шпаргалку |

## Aliases

| Alias | Раскрывается в |
|---|---|
| `la`, `ll`, `lt` | eza: все файлы, подробный список, дерево глубиной 2 |
| `..`, `...`, `....` | `cd ..`, `cd ../..`, `cd ../../..` |
| `reload` | `exec zsh` |
| `gs`, `ga`, `gc`, `gp` | status, add, commit, push |
| `gd`, `gds`, `gl` | diff, staged diff, граф истории |
| `lg` | `lazygit` |
| `dc`, `dps`, `dcu`, `dcd`, `dcl` | частые Docker Compose/контейнеры |
| `k`, `kgp`, `kgs`, `kgd`, `kctx` | kubectl и частые get/context |
| `bp`, `bt` | `btop`, `btm` |
| `ports` | локальные слушающие TCP-порты |

## Навигация и поиск файлов

### zoxide

`zoxide` запоминает каталоги, в которые вы заходите обычным `cd`.

```bash
z gopher                 # перейти в лучший каталог с «gopher»
zi                       # интерактивно выбрать каталог
z -                      # перейти в предыдущий каталог zoxide
zoxide query gopher      # только показать найденный путь
```

Если каталог ещё не известен zoxide, один раз зайдите в него через `cd`.

### fzf

```bash
fzf                      # выбрать строку из stdin
fd -t f | fzf            # выбрать файл
git branch --all | fzf    # выбрать ветку
```

Горячие клавиши в Zsh:

| Клавиша | Действие |
|---|---|
| `Ctrl+R` | Atuin: поиск по всей истории |
| `Ctrl+T` | выбрать файл и вставить его путь |
| `Alt+C` | выбрать каталог и перейти в него |
| `Tab` | локально: fzf-tab; по SSH: стандартное Zsh completion |
| `↑` / `↓` | history substring search по уже введённому тексту |
| `→` | принять серую подсказку autosuggestions |

### fd

```bash
fd docker-compose                    # файлы/каталоги с именем
fd -t f -e go                        # только Go-файлы
fd -H '^\.env'                       # включая скрытые файлы
fd -E vendor -E node_modules TODO     # исключить каталоги
fd -x bat {}                          # запустить команду для каждого результата
```

Ключи: `-t f` — файлы, `-t d` — каталоги, `-e go` — расширение, `-H` — скрытые,
`-E` — исключение, `-x` — выполнить команду.

### ripgrep

```bash
rg 'RegisterCollector'                   # поиск во всём проекте
rg -i 'registercollector'                # без учёта регистра
rg 'context.Context' -g '*.go'           # только Go
rg -C 3 'failed to register'              # 3 строки контекста
rg -l 'TODO'                              # только имена файлов
rg --hidden -g '!.git/**' 'TOKEN'         # скрытые, но не .git
rg -n 'TODO|FIXME' internal/               # номера строк и регулярное выражение
```

Ключи: `-i` — ignore case, `-g` — glob, `-C N` — контекст, `-l` — только файлы,
`-n` — номера строк, `--hidden` — скрытые файлы.

## Просмотр файлов

```bash
ls                         # удобный список
ll                         # права, размер, Git-статус, скрытые файлы
lt                         # дерево на два уровня
cat main.go                # bat с подсветкой
bat --language yaml compose.yml
bat --style=numbers file.txt
```

`cat` в интерактивной оболочке ведёт на `bat`; в скриптах используйте обычный
`command cat`, если нужен строго стандартный вывод.

## Диск: dust и ncdu

```bash
dust ~                     # быстрый обзор места в домашнем каталоге
dust -d 2 ~/Development     # ограничить глубину
ncdu ~                      # интерактивно пройти по размерам
sudo ncdu /                 # весь сервер (осторожно)
```

`dust` лучше для моментального обзора. `ncdu` удобнее, когда нужно стрелками
провалиться в большой каталог. В `ncdu` клавиша `d` может удалить выделенное:
проверяйте путь и не используйте удаление наугад.

## HTTP и API: xh

```bash
xh GET http://localhost:8080/health
xh GET https://api.example.com/v1/me Authorization:"Bearer $TOKEN"
xh POST http://localhost:8080/v1/tasks name=check enabled:=true interval:=10
xh POST http://localhost:8080/upload file@./image.jpg
xh --download GET https://example.com/file.zip
```

`name=value` отправляет строку формы, `name:=true` — JSON boolean/number/object,
`Header:value` задаёт заголовок, `file@path` загружает файл. Для автоматизации и
совместимости по-прежнему выбирайте `curl`.

## JSON и YAML

```bash
xh GET http://localhost:8080/api | jq
jq '.items[] | select(.enabled == true)' data.json
jq -r '.items[].name' data.json
jq '{name: .name, count: (.items | length)}' data.json

yq '.services.backend.environment' compose.yml
yq '.items[] | select(.enabled == true)' config.yaml
yq -i '.services.api.replicas = 3' compose.yml
yq -o=json '.' config.yml | jq
```

`jq -r` выводит строки без JSON-кавычек. В `yq -i` изменяет файл на месте —
сначала сделайте Git diff или копию.

## Git, Delta, lazygit и GitHub CLI

```bash
gs                          # короткий status с веткой
gd                          # красивый diff через Delta
gds                         # только staged diff
gl                          # граф всех веток
lg                          # открыть lazygit
git diff --cached
git show HEAD
git diff --word-diff
gh auth login
gh pr list
gh pr create --fill
gh pr checkout 123
gh run list
gh run watch
```

В Delta: `n`/`N` переходят между файлами или блоками diff, `q` закрывает pager.
`lazygit` особенно хорош для выбора отдельных строк в stage, stash, rebase и
разрешения конфликтов. Всегда читайте подтверждения перед force-push/rebase.

## Docker и Kubernetes

```bash
dps                         # контейнеры, имена, статус и порты
dc ps
dcu                         # docker compose up
dcu -d                      # поднять в фоне
dcl api                     # следить за логами сервиса api
dcd                         # остановить compose-проект

kgp                         # pod'ы
k get pods -A
k logs -f deploy/api
kctx                        # текущий context
```

Алиасы Kubernetes доступны только когда найден `kubectl`.

## Процессы, порты и логи

```bash
bp                          # btop: быстрый обзор CPU/RAM/сети
bt                          # bottom: фильтры процессов и графики
procs postgres
procs --tree
ports                       # macOS: слушающие TCP-порты
sudo lsof -nP -iTCP:8080 -sTCP:LISTEN
ss -lntp                    # Ubuntu: слушающие порты

lnav app.log
lnav logs/*.log
lnav -t app.log             # tail-подобный режим
```

В `lnav` используйте `/ошибка` для поиска, `n`/`N` для совпадений, `q` для
выхода. JSON-логи и timestamps он распознаёт автоматически.

## Бенчмарки и watch

```bash
hyperfine 'go test ./...'
hyperfine --warmup 3 './old-parser test.json' './new-parser test.json'
hyperfine --export-json benchmark.json 'go test ./...'

watchexec -e go -- go test ./...
watchexec -e py -- pytest
watchexec -w cmd -e go -- go run ./cmd/api
```

`hyperfine` сравнивает внешние команды; для Go microbenchmarks используйте
`go test -bench=. -benchmem`. У `watchexec --` всё справа — запускаемая команда.

## tmux

tmux нужен прежде всего для SSH: сессия переживёт разрыв соединения.

```bash
tmux new -s work             # создать сессию
tmux ls                      # список сессий
tmux attach -t work          # подключиться
tmux kill-session -t work    # завершить сессию
```

Префикс — `Ctrl+A`; далее отпустите клавиши и нажмите вторую:

| Клавиши | Действие |
|---|---|
| `Ctrl+A c` | новое окно в текущем каталоге |
| `Ctrl+A |` / `Ctrl+A -` | split горизонтально / вертикально |
| `Ctrl+A h/j/k/l` | перейти к соседней панели |
| `Ctrl+A H/J/K/L` | изменить размер панели |
| `Ctrl+A 1…9` | перейти к окну |
| `Ctrl+A d` | отключиться, оставив процессы работать |
| `Ctrl+A [` | scroll/copy mode (`q` — выход) |
| `Ctrl+A r` | перечитать `.tmux.conf` |

Чтобы передать `Ctrl+A` программе внутри tmux, нажмите `Ctrl+A Ctrl+A`.

## История и completion

`Ctrl+R` открывает Atuin. Наберите часть команды, выберите результат стрелками,
Enter выполнит, а Esc отменит. История локальна, пока вы сами не включите sync.

`↑` и `↓` ищут только среди исторических команд, начинающихся с уже введённого
текста. Серое продолжение справа — `zsh-autosuggestions`; принять его можно
стрелкой `→` или End. Локально `Tab` после `git`, `docker`, пути или опции
включает `fzf-tab`: печатайте часть названия, выбирайте стрелками, подтверждайте
Enter. По SSH работает обычное completion Zsh: без `fzf-tab`, autosuggestions и
syntax highlighting. Prompt при этом остаётся двухстрочным и информативным.

## Prompt и Ghostty

Powerlevel10k настроен в две строки без рамок: user/host, каталог, Git и статус
на первой; `❯` и команда — на второй. Старые команды сжимаются благодаря
transient prompt; ошибка отмечается красным `❯`.

Ghostty использует Catppuccin Mocha, Meslo Nerd Font Mono 15pt, небольшую
прозрачность и blur. Для совместимости с SSH установлен `xterm-256color`, а
автоматическая shell integration отключена. После смены конфигурации полностью
перезапустите Ghostty или нажмите `Cmd+Shift+,`.

## Частые сценарии

```bash
# Где съело место?
dust ~ && ncdu ~

# Найти вызов в Go, исключив vendor.
rg -g '*.go' -g '!vendor/**' 'context.Context'

# Выбрать изменённый файл и открыть в bat.
git diff --name-only | fzf | xargs -r bat

# Смотреть несколько логов, упорядоченных по timestamp.
lnav logs/*.log

# Проверить локальный API и красиво разобрать JSON.
xh GET http://localhost:8080/v1/status | jq

# Тестировать Go после каждого изменения.
watchexec -e go -- go test ./...

# Не потерять процесс на сервере.
ssh server
tmux new -s deploy
# запустить команду, затем Ctrl+A d; позже: tmux attach -t deploy
```

## Диагностика

### Ломается отрисовка после Tab

1. Убедитесь, что нет второго `compinit` после загрузки Oh My Zsh.
2. Проверьте `zsh -n ~/.zshrc` и откройте новый shell: `exec zsh`.
3. Убедитесь, что в SSH-сессии `fzf-tab` не загружен: shared-конфиг отключает
   его автоматически и оставляет обычное completion Zsh.
4. Не добавляйте тяжёлую рамку или правый status prompt P10K.

### Иконки или ширина prompt выглядят неправильно

```bash
ghostty +list-fonts | rg -i 'Meslo.*Nerd'
```

Установите выбранный Nerd Font и полностью перезапустите Ghostty. Один
моноширинный Nerd Font лучше цепочки fallback-шрифтов.

### Ghostty по SSH ведёт себя странно

На удалённой машине:

```bash
echo "$TERM"
infocmp xterm-ghostty >/dev/null && echo OK || echo MISSING
```

Если terminfo отсутствует, скопируйте готовую запись Ghostty с Mac:

```bash
ssh mrgorkiy 'mkdir -p ~/.terminfo/78'
scp /Applications/Ghostty.app/Contents/Resources/terminfo/78/xterm-ghostty \
  mrgorkiy:~/.terminfo/78/xterm-ghostty
```

Замените `mrgorkiy` на SSH-host alias. Не оставляйте подмену `TERM` как
постоянное решение: правильный terminfo сохраняет возможности Ghostty.

### Команда не найдена на Ubuntu

```bash
command -v eza dust xh yq lazygit gh atuin
echo "$PATH"
```

Cargo кладёт программы в `~/.cargo/bin`, а `yq` — в `~/.local/bin`; общий
`.zshrc` добавляет оба пути в `PATH`.

### Вернуть старую конфигурацию

Все заменённые файлы находятся в `~/.dotfiles-backups/<дата-время>/`. Удалите
конкретную symlink и переместите нужный файл обратно; не копируйте старый
`.zshrc` поверх нового без переноса личных настроек в `.zshrc.local`.
