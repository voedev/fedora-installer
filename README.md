# Fedora Installer

Кастомный bash-скрипт для первоначальной настройки и установки приложений + dev environment

## Настройка

Вы можете установить значение для глобальных переменных. Например для git user.name, git user.email или выбрать нужную версию PHP (8.2 по умолчанию)

```bash
# ****************************** Variables ******************************

GIT_NAME=""
GIT_EMAIL=""
PHP_VERSION="8.2"

# ***********************************************************************
```

## Установка

```bash
sudo chmod u+x fedora_installer.sh && ./fedora_installer.sh
```

