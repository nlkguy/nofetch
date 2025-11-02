
#!/bin/sh
# nofetch - a neofetch with no external dependencies.
# author - nlkguy
# version - 0.3



logo(){
    echo "
    ░█▀█░█▀█░█▀▀░█▀▀░▀█▀░█▀▀░█░█
    ░█░█░█░█░█▀▀░█▀▀░░█░░█░░░█▀█ no-fetch ain't like neofetch
    ░▀░▀░▀▀▀░▀░░░▀▀▀░░▀░░▀▀▀░▀░▀
"
}
main(){
    
    logo

    # printf "\tOS\t:\t" && . /etc/os-release && echo "$PRETTY_NAME" 

    . /etc/os-release 2>/dev/null
    os="${PRETTY_NAME:-Unknown OS}"
    kernel="$(uname -r)"
    echo "\tOS\t: $os ($kernel)"

    #printf "\tHost\t:\t%s (%s)\n" "$(hostname)" "$(hostname -I | awk '{print $1}')"
    #printf "\tKernel\t:\t" && uname -r

    host="$(hostname)"
    ip="$(ip addr show | awk '/inet / && !/127.0.0.1/ {sub(/\/.*/,"",$2); print $2; exit}')"
    echo "\tHost\t: $host (${ip:-no net})"



    #printf "\tUptime\t:\t" 
    #awk '{d=$1/86400; h=($1%86400)/3600; m=($1%3600)/60; printf "%dd %02dh %02dm\n", d,h,m}' /proc/uptime





    #printf "\tCPU\t:\t" && awk -F: '/model name/ {print $2; exit}' /proc/cpuinfo | sed 's/^ //'

    cpu="$(awk -F: '/model name/{print $2; exit}' /proc/cpuinfo | sed 's/^ //')"
    arch="$(uname -m)"
    echo "\tCPU\t: $cpu ($arch)"


    gpu="$(lspci 2>/dev/null | awk -F': ' '/VGA|3D|Display/{print $3; exit}')"
    [ -z "$gpu" ] && gpu="$(grep -m1 'VGA' /proc/bus/pci/devices 2>/dev/null || echo 'N/A')"
    res="$(awk -F'x' '/x/ {print $1"x"$2; exit}' /sys/class/graphics/fb0/modes 2>/dev/null)"
    echo "\tGPU\t: ${gpu:-N/A} (${res:-N/A})"




    #printf "\tMemory\t:\t" 
    #awk '/MemTotal/{t=$2} 
    #    /MemAvailable/{a=$2}   
    #    END{printf "%.1f / %.1f GiB\n", (t-a)/1048576, t/1048576}' /proc/meminfo

    awk '/MemTotal/{t=$2}/MemAvailable/{a=$2}
        END{u=(t-a); p=u*100/t; 
        printf "\tMem\t: %.1f / %.1f GiB (%.0f%%)\n", u/1048576, t/1048576, p}' /proc/meminfo

    awk '{d=$1/86400; h=($1%86400)/3600; m=($1%3600)/60;
    printf "\tUptime\t: %dd %02dh %02dm\n", d,h,m}' /proc/uptime

        df -h / 2>/dev/null | awk 'NR==2 {printf "\tDisk\t: %s / %s (%s)\n", $3, $2, $6}'

}


main "$@"