## Инструкция по развёртыванию

1. **Terraform**:

```bash
cd terraform
terraform init
terraform apply -auto-approve
```

2. **Ansible**:

```bash
cd ansible
ansible-playbook -i inventory.ini setup_host.yml
```

3. **Monitoring**:

```bash
cd scripts
./monitor.sh docker
```

4. **Docker Compose**:

```bash
cd /opt/app
docker compose up -d
curl http://localhost
```

## Подтверждение результатов работы и отладки

<img width="568" height="52" alt="image" src="https://github.com/user-attachments/assets/9df104df-9f80-4770-bdef-efb42eb31831" />

<img width="942" height="495" alt="image" src="https://github.com/user-attachments/assets/14efc060-d545-4d44-af39-784e2fce1027" />

<img width="555" height="121" alt="image" src="https://github.com/user-attachments/assets/714906c2-a177-41d8-8572-7369eacde8f6" />

<img width="944" height="235" alt="image" src="https://github.com/user-attachments/assets/250f115c-d622-4368-ae6b-1015e7bf8740" />

## Краткое описание архитектурных решений

- **Terraform**: Для обеспечения полной независимости от облачных сервисов и внешней инфраструктуры использован локальный Docker-провайдер (`kreuzwerker/docker`). Это позволяет поднимать изолированные сети и контейнерные среды прямо на целевом хосте, фиксируя состояние в `terraform.tfstate` без завязки на сторонние API.
- **Конфигурация хоста (Ansible)**: Использовано локальное подключение (`ansible_connection=local`) для автоматической настройки целевого VPS. Плейбук задействует официальный репозиторий Docker для установки актуальных пакетов. В системе создаётся отдельный пользователь `deployer` с правами `sudo` без ввода пароля для обеспечения принципа наименьших привилегий при деплое.
- **Мониторинг (Bash)**: Скрипт `monitor.sh` использует стандартный CLI Linux (`systemctl`, `journalctl`, `grep`, `awk`). Он умеет проверять активный статус юнитов systemd, выводить последние строки журналов при сбоях и агрегировать ошибки за указанный временной интервал.
- **Контейнеризация (Docker Compose)**: Реализована классическая двухуровневая схема: Nginx в роли Reverse Proxy принимает входящие запросы на 80-м порту и перенаправляет их на внутренний сервис `app` в изолированной виртуальной сети моста (`app_net`). Это скрывает прямой доступ к приложению из внешней сети.

---
