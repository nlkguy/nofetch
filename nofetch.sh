
#!/bin/sh
# nofetch - a neofetch with no external dependencies.
# author - nlkguy
# version - 0.3



logo(){
    echo "
░█▀█░█▀█░█▀▀░█▀▀░▀█▀░█▀▀░█░█
░█░█░█░█░█▀▀░█▀▀░░█░░█░░░█▀█
░▀░▀░▀▀▀░▀░░░▀▀▀░░▀░░▀▀▀░▀░▀
"
}
main(){
    logo

    printf "\tOS\t:\t" && . /etc/os-release && echo "$PRETTY_NAME" 

    printf "\tHost\t:\t%s (%s)\n" "$(hostname)" "$(hostname -I | awk '{print $1}')"

    printf "\tKernel\t:\t" && uname -r

    printf "\tUptime\t:\t" 
    awk '{d=$1/86400; h=($1%86400)/3600; m=($1%3600)/60; printf "%dd %02dh %02dm\n", d,h,m}' /proc/uptime

    printf "\tCPU\t:\t" && awk -F: '/model name/ {print $2; exit}' /proc/cpuinfo | sed 's/^ //'

    printf "\tMemory\t:\t" 
    awk '/MemTotal/{t=$2} 
        /MemAvailable/{a=$2}   
        END{printf "%.1f / %.1f GiB\n", (t-a)/1048576, t/1048576}' /proc/meminfo

}


main "$@"