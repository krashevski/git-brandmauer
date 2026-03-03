# git-security

Набор скриптов для безопасного управления Git и контроля доступа к сети при работе с репозиториями.

## Описание

git-security помогает:

Проверять состояние сети.

Включать или отключать сеть, изменять пароль при необходимости в аварийном режиме.

Регистрировать действия, связанные с безопасностью Git и сети.

## Операционные скрипты сетевой безопасности

- `bin/panic.sh` — управляет включением и выключением сети, а также изменением паролей для режима паники (аварийное завершение работы).
- `bin/network-pause.sh` — центральный контроллер паузы сети.
- `bin/net-status.sh` — состояние сети.
- `bin/burn-zip-archives.sh` — запись ZIP-архивов на CD/DVD.
- `bin/menu.sh` — меню управления GIT-SECURITY.


## Скрипты Git-brandmauer

- `chesk.sh` - 
- `common.sh` - скрипт определения режима
- `git-brandmauer-mode` - переключение режима текущего репозитория
= `install.sh` - production Installer (hooks-only)
- `menu.sh` - git-brandmauer interactive menu (per-repo)
- `uninstall.sh` - git-brandmauer uninstall script
- `hooks/pre-fetch` - ручная настройка
- `hooks/pre-hook` - шаблон триггера хука для команды git
- `hooks/pre-merge-commit` - триггер хука git merge
- `hooks/pre-push` - триггер хука git push
- `hook/pre-rebase` - триггер хука git rebase
- `state/mode` - данные о состоянии


## Зависимости

`git-security` использует общие функции из библиотеки [`shared-lib`](https://github.com/krashevski/shared-lib).  
Для работы проекта необходимо подключить `shared-lib` в каталог `lib/shared-lib`.

### Установка `shared-lib` через сабмодуль

Если вы клонируете проект впервые:

```bash
git clone --recurse-submodules https://github.com/krashevski/git-security
```

## Установка git-security

1. Клонируйте репозиторий:

```bash
git clone https://github.com/krashevski/git_security
```

2. Перейдите в каталог проекта:
```bash
cd git-security
```

3. Предоставьте скриптам права на выполнение:
```bash
chmod +x *.sh
```

## Использование

Запустите основной скрипт сетевой безопасности:
```bash
./net-security/bin/menu.sh
```
Логи создаются в каталоге ./logs.

Запустите скрипт установки брандмауера:
```bash
./git-brandmauer/install.sh
```

Запустите скрипт управления брандмауером:
```bash
././git-brandmauer/menu.sh
```

## Примечания

* Скрипты были протестированы в домашней среде (~/.scripts/git_security).

* Также можно использовать в тестовом режиме, изменив пути к логам и статус.

## Лицензия

MIT

## Автор

Владислав Крашевский поддержка ChatGPT
