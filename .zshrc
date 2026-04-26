
## ===== Автозагрузка Pywal =====
# Восстановление цветовой схемы при запуске терминала
if [[ -f ~/.cache/wal/sequences ]]; then
    cat ~/.cache/wal/sequences
fi

# Принудительное обновление цветов из текущих обоев (если файл sequences не существует)
if [[ ! -f ~/.cache/wal/sequences || -z "$(cat ~/.cache/wal/sequences)" ]]; then
    if [[ -f ~/.fehbg ]]; then
        wallpaper=$(grep -oP "(?<=').*?(?=')" ~/.fehbg | head -1)
        [[ -f "$wallpaper" ]] && wal -i "$wallpaper" >/dev/null 2>&1
    fi
fi

fastfetch
# ===== Ленивая загрузка =====
export NVM_DIR="$HOME/.nvm"
lazy_load_nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
nvm() { lazy_load_nvm; nvm "$@"; }
node() { lazy_load_nvm; node "$@"; }
npm() { lazy_load_nvm; npm "$@"; }
npx() { lazy_load_nvm; npx "$@"; }

# ===== Oh-My-Zsh =====
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="spaceship"
plugins=(
  git sudo web-search dirhistory
  zsh-autosuggestions zsh-syntax-highlighting
  colored-man-pages copypath copyfile copybuffer history
)
source $ZSH/oh-my-zsh.sh
source /home/daniil/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ===== Spaceship Prompt =====


# ===== Основные алиасы =====
alias wlan='ip a | grep "wlan"'
alias rabbit='docker run --rm -p 15672:15672 -p 5672:5672 rabbitmq:3.10.7-management'
alias redis='docker run --rm -d --name redis-stack -p 6379:6379 -p 8001:8001 redis/redis-stack'
alias pizdec="sudo archarchive"
alias otla='otter-launcher'
alias g='git'
alias earth='curl http://ascii.live/earth'
alias cls='clear'
alias top='btop'
alias n='nvim'
alias gs='git status'
alias ll='exa --icons --long --header -lah'
alias ff='fastfetch'
alias meow='nyancat'
alias cmg='cmatrix'
alias alg='nvim ~/Projects/Python/CodeWars/'
alias server='cd ~/NeoForgeServer/NeoForgeServer/ && ./run.sh'
alias mc='java -jar HMCL-3.7.3.jar'
alias commit="git add . && git commit -m"
alias fish="asciiquarium"
alias theme="~/Scripts/theme_niri.sh"
# ===== Python алиасы =====
# Goto
[[ -f /home/daniil/Scripts/goto.py ]] && alias goto='python /home/daniil/Scripts/goto.py'
# Copy
[[ -f /home/daniil/Scripts/my_copy.py ]] && alias copy='python /home/daniil/Scripts/my_copy.py'
# Calc
[[ -f /home/daniil/Scripts/calc.py ]] && alias calc='python /home/daniil/Scripts/calc.py'
# Music
[[ -f /home/daniil/Scripts/music.py ]] && alias music='python /home/daniil/Scripts/music.py'
# Noisy
[[ -f /home/daniil/Scripts/yt.py ]] && alias ytd='python /home/daniil/Scripts/yt.py'
[[ -f ~/noisy/noisy.py ]] && alias noisy='cd ~/noisy && python noisy.py --config config.json'
[[ -f /home/daniil/Scripts/nums.py ]] && alias nums='python /home/daniil/Scripts/nums.py'

# ===== Pywal =====
[[ -f ~/.cache/wal/sequences ]] && cat ~/.cache/wal/sequences
alias feh='feh --bg-fill --no-fehbg && wal -i'
alias wal-random='wal -i ~/Обои/ -n'

# ===== Экспорты =====
export EDITOR='nvim'
export VISUAL='nvim'
export GTK_THEME=Arc-Dark
export QT_STYLE_OVERRIDE=kvantum
export KITTY_CONFIG_DIRECTORY="$HOME/.config/kitty"
export PATH="$HOME/.local/bin:$PATH"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ===== Цвета man =====
export LESS_TERMCAP_mb=$'\e[1;35m'
export LESS_TERMCAP_md=$'\e[1;35m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;34m'
export LESS_TERMCAP_ue=$'\e[0m'

# ===== Завершения =====
autoload -Uz compinit
zcompdump="$HOME/.zcompdump"
if [[ -f "$zcompdump" ]]; then
  current_day=$(date +'%j')
  file_day=$(stat -c '%Y' "$zcompdump" 2>/dev/null | xargs -I{} date -d '@{}' +'%j' 2>/dev/null)
  [[ "$current_day" != "$file_day" ]] || [[ ! -s "$zcompdump" ]] && compinit || compinit -C
else
  compinit
fi

# ===== Дополнительно =====
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env" &!
command_not_found_handler() {
    echo "Check here: https://duckduckgo.com/?q=$1+linux"
    return 127
}

