#!/bin/bash

# Проверяем, запущен ли какой-либо плеер
player_status=$(playerctl status 2>/dev/null)

if [ "$player_status" = "Playing" ] || [ "$player_status" = "Paused" ]; then
    # Пробуем получить Название и Артиста. 
    # Если Артист пустой, выведем только название.
    info=$(playerctl metadata --format "{{ title }} - {{ artist }}" 2>/dev/null)
    
    # Если вдруг title пустой (бывает в ТГ), попробуем взять имя файла/процесса
    if [ -z "$info" ] || [ "$info" = " - " ]; then
        info=$(playerctl metadata --format "{{ xesam:title }}" 2>/dev/null)
    fi

    if [ "$player_status" = "Paused" ]; then
        echo "⏸ $info"
    else
        echo "󰎆 $info"
    fi
else
    # Твой вариант для тишины
    echo "󰝚 <span foreground='#676767'>󰅖</span>"
fi
