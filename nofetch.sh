
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

    printf "\tMemory\t:\t" 
    awk '/MemTotal/{t=$2} 
        /MemAvailable/{a=$2}   
        END{printf "%.1f / %.1f GiB\n", (t-a)/1048576, t/1048576}' /proc/meminfo

}


main "$@"