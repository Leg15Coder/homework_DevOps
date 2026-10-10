#!/bin/bash

if [ -z "$1" ]; then
    echo "Ошибка: не указано имя службы."
    exit 1
fi

SERVICE=$1

echo "=========================================="
echo " Проверка статуса службы: $SERVICE"
echo "=========================================="

STATUS=$(systemctl is-active "$SERVICE" 2>/dev/null)

if [ "$STATUS" = "active" ]; then
    echo "Статус: ACTIVE (служба работает)"
else
    echo "Статус: $STATUS (служба не активна)"
    echo ""
    echo "--- Последние 10 строк лога $SERVICE ---"
    journalctl -u "$SERVICE" -n 10 --no-pager
fi

echo ""
SYSLOG_FILE="/var/log/syslog"

if [ -f "$SYSLOG_FILE" ]; then
    ERROR_COUNT=$(grep -iE "error|failed" "$SYSLOG_FILE" | awk -v d1="$(date +'%b %e %H')" -v d2="$(date -d '1 hour ago' +'%b %e %H')" '$0 ~ d1 || $0 ~ d2' | wc -l)
    echo "Количество ошибок в $SYSLOG_FILE за последний час: $ERROR_COUNT"
else
    ERROR_COUNT=$(journalctl --since "1 hour ago" -p err --no-pager | wc -l)
    echo "Файл $SYSLOG_FILE не найден. Ошибок в journalctl за последний час: $ERROR_COUNT"
fi
