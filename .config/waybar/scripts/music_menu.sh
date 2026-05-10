#!/bin/bash

# Получаем инфу о текущем треке
status=$(playerctl status 2>/dev/null)

if [ -z "$status" ]; then
    notify-send "Telegram" "Музыка не запущена"
    exit 1
fi

artist=$(playerctl metadata artist)
title=$(playerctl metadata title)

# Список кнопок для меню
options="󰐎 Пауза/Плей\n󰒭 Следующий\n󰒮 Предыдущий"

# Запускаем wofi в режиме меню
chosen=$(echo -e "$options" | wofi --dmenu --conf=/home/daniil/.dotfiles/.config/wofi/config_music --prompt "Управление: $title")

case $chosen in
    *Пауза*) playerctl play-pause ;;
    *Следующий*) playerctl next ;;
    *Предыдущий*) playerctl previous ;;
esac
