
printf "\n=== NVIDIA DRIVER CHECK ===\n"
lsmod | grep nvidia

printf "\n=== DISPLAY SERVER CHECK ===\n"
echo $XDG_SESSION_TYPE

printf "\n=== AUDIO SUBSYSTEM ===\n"
pactl info 2>/dev/null | grep 'Server Name'

printf "\n=== PIPEWIRE SERVICES ===\n"
systemctl --user is-active pipewire
systemctl --user is-active pipewire-pulse

printf "\n=== NVIDIA PACKAGES INSTALLED ===\n"
pacman -Qs nvidia
