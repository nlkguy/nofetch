
#!/bin/sh
# nofetch - a neofetch with no external dependencies.
# author - nlkguy
# version - 0.3

VERSION="0.3"

usage(){
    cat <<EOF
nofetch - minimal system info tool with zero dependencies

Usage:
  nofetch [options]

Options:
  -l, --logo        Show ASCII logo before system info
  -h, --help        Show this help message
  -v, --version     Show version info

EOF
}

version(){
    #printf "\n\tnofetch v$VERSION by nlkguy\n\n"
    printf "\nnofetch v%s by nlkguy\n\n" "$VERSION"
}

logo(){
    echo "
    ░█▀█░█▀█░█▀▀░█▀▀░▀█▀░█▀▀░█░█
    ░█░█░█░█░█▀▀░█▀▀░░█░░█░░░█▀█ no-fetch ain't like neofetch
    ░▀░▀░▀▀▀░▀░░░▀▀▀░░▀░░▀▀▀░▀░▀
"
}

sysinfo(){
    
    . /etc/os-release 2>/dev/null
    os="${PRETTY_NAME:-Unknown OS}"
    kernel="$(uname -r)"
    printf "\tOS\t: $os ($kernel)"

    host="$(hostname)"
    ip="$(ip addr show | awk '/inet / && !/127.0.0.1/ {sub(/\/.*/,"",$2); print $2; exit}')"
    printf "\n\tHost\t: $host (${ip:-no net})"

    cpu="$(awk -F: '/model name/{print $2; exit}' /proc/cpuinfo | sed 's/^ //')"
    arch="$(uname -m)"
    printf "\n\tCPU\t: $cpu ($arch)"

    gpu="$(lspci 2>/dev/null | awk -F': ' '/VGA|3D|Display/{print $3; exit}')"
    [ -z "$gpu" ] && gpu="$(grep -m1 'VGA' /proc/bus/pci/devices 2>/dev/null || echo 'N/A')"
    res="$(cat /sys/class/graphics/fb0/modes 2>/dev/null | sed -n 's/.*:\([0-9]\+x[0-9]\+\).*/\1/p' | head -n1)"
    [ -z "$res" ] && res="$(xrandr 2>/dev/null | awk '/\*/ {print $1; exit}')"    
    printf "\n\tGPU\t: ${gpu:-N/A} (${res:-N/A})"

    awk '/MemTotal/{t=$2}/MemAvailable/{a=$2}END{u=(t-a); p=u*100/t; 
    printf "\n\tMem\t: %.1f / %.1f GiB (%.0f%%)\n", u/1048576, t/1048576, p}' /proc/meminfo

    awk '{d=$1/86400; h=($1%86400)/3600; m=($1%3600)/60;
    printf "\tUptime\t: %dd %02dh %02dm\n", d,h,m}' /proc/uptime

    df -h / 2>/dev/null | awk 'NR==2 {printf "\tDisk\t: %s / %s (%s)\n", $3, $2, $6}'

}

main(){

    show_logo=true
    while [ $# -gt 0 ]; do
        case "$1" in
            -l|--logo)
                show_logo=true ;;
            -h|--help)
                usage; exit 0 ;;
            -v|--version)
                version; exit 0 ;;
            -*)
                echo "nofetch: unknown option: $1"
                echo "Try 'nofetch --help' for usage."
                exit 1 ;;
        esac
        shift
    done

    $show_logo && logo
    sysinfo
}


main "$@"