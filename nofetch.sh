
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

    printf "\tOS\t:\t" 
    source /etc/os-release && echo "$PRETTY_NAME" 

    printf "\tHost\t:\t" 
    hostname

    printf "\tKernel\t:\t" 
    uname -r

    printf "\tUptime\t:\t" 
    cat /proc/uptime

    # printf "\tCPU\t:\t" 
    # grep -m1 "model name" /proc/cpuinfo

   # printf "\tMemory\t:\t" 
   # grep -E "MemTotal|MemAvailable" /proc/meminfo | sed '

}


main "$@"