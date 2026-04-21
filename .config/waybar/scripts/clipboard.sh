#!/bin/bash

CLIPBOARD_FILE="/tmp/clipboard_history.txt"
MAX_ENTRIES=20

# Инициализация файла
init_file() {
    if [ ! -f "$CLIPBOARD_FILE" ]; then
        touch "$CLIPBOARD_FILE"
    fi
}

# Получить текущий буфер обмена
get_current_clipboard() {
    if command -v wl-paste >/dev/null; then
        wl-paste 2>/dev/null
    elif command -v xclip >/dev/null; then
        xclip -selection clipboard -o 2>/dev/null
    fi
}

# Добавить новую запись
add_to_history() {
    local content="$1"
    
    # Игнорируем пустые строки
    if [ -z "$content" ]; then
        return
    fi
    
    # Экранируем спецсимволы для sed
    content_escaped=$(echo "$content" | sed 's/[&/\]/\\&/g')
    
    # Удаляем дубликат если есть
    sed -i "\:^$content_escaped$:d" "$CLIPBOARD_FILE"
    
    # Добавляем в начало
    sed -i "1i$content_escaped" "$CLIPBOARD_FILE"
    
    # Оставляем только MAX_ENTRIES записей
    sed -i "$((MAX_ENTRIES+1)),\$d" "$CLIPBOARD_FILE"
}

# Показать индикатор (иконку + количество)
show_indicator() {
    local count=$(wc -l < "$CLIPBOARD_FILE" 2>/dev/null || echo "0")
    if [ "$count" -gt 0 ] && [ -s "$CLIPBOARD_FILE" ]; then
        echo "$count"
    else
        echo ""
    fi
}

# Показать меню через wofi/fuzzel/rofi
show_menu() {
    local entries=$(cat "$CLIPBOARD_FILE" 2>/dev/null | head -20)
    
    if [ -z "$entries" ]; then
        notify-send "Clipboard" "History is empty"
        return
    fi
    
    # Выбор лаунчера (wofi рекомендуется)
    if command -v wofi >/dev/null; then
        local selected=$(echo "$entries" | wofi --dmenu --prompt "Clipboard History" --width 500 --height 400)
    elif command -v fuzzel >/dev/null; then
        local selected=$(echo "$entries" | fuzzel --dmenu -p "Clipboard: ")
    elif command -v rofi >/dev/null; then
        local selected=$(echo "$entries" | rofi -dmenu -p "Clipboard History")
    else
        notify-send "Clipboard" "No launcher found (wofi/fuzzel/rofi)"
        return
    fi
    
    # Копируем выбранное обратно в буфер
    if [ -n "$selected" ]; then
        if command -v wl-copy >/dev/null; then
            echo "$selected" | wl-copy
        elif command -v xclip >/dev/null; then
            echo "$selected" | xclip -selection clipboard
        fi
        notify-send "Clipboard" "Copied: $(echo "$selected" | cut -c1-50)..."
    fi
}

# Мониторинг буфера обмена (демон)
monitor_clipboard() {
    init_file
    
    local last_content=""
    
    while true; do
        current_content=$(get_current_clipboard)
        
        if [ -n "$current_content" ] && [ "$current_content" != "$last_content" ]; then
            add_to_history "$current_content"
            last_content="$current_content"
        fi
        
        sleep 0.5
    done
}

# Основная логика
case "${1:-}" in
    indicator)
        init_file
        show_indicator
        ;;
    menu)
        show_menu
        ;;
    monitor)
        monitor_clipboard
        ;;
    *)
        echo "Usage: $0 {indicator|menu|monitor}"
        exit 1
        ;;
esac
