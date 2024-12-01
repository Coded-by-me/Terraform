#!/bin/bash

ascii_picture="
                                                            
               .                                            
              :++=:                                         
              :+++++=-.                                     
              .+++++++++ .                   .              
              .+++++++++.=+=-.           .-=+-              
              :+++++++++.=+++++=:    .:=+++++-              
               .:=++++++.=+++++++++ +++++++++-              
                   :-+++.=+++++++++.+++++++++-         \$\$\$\$\$\$\$\$\                                      \$\$\$\$\$\$\                                   
                      .- =+++++++++.+++++++++-         \__\$\$  __|                                    \$\$  __\$\$\                                  
                         .:=+++++++.+++++++=:             \$\$ | \$\$\$\$\$\$\   \$\$\$\$\$\$\   \$\$\$\$\$\$\  \$\$\$\$\$\$\  \$\$ /  \__|\$\$\$\$\$\$\   \$\$\$\$\$\$\  \$\$\$\$\$\$\\$\$\$\$\  
                         =+-::-=+++.+++=-.                \$\$ |\$\$  __\$\$\ \$\$  __\$\$\ \$\$  __\$\$\ \____\$\$\ \$\$\$\$\    \$\$  __\$\$\ \$\$  __\$\$\ \$\$  _\$\$  _\$\$\ 
                         =+++++-::- -.                    \$\$ |\$\$\$\$\$\$\$\$ |\$\$ |  \__|\$\$ |  \__|\$\$\$\$\$\$\$ |\$\$  _|   \$\$ /  \$\$ |\$\$ |  \__|\$\$ / \$\$ / \$\$ |
                         =++++++++=                       \$\$ |\$\$   ____|\$\$ |      \$\$ |     \$\$  __\$\$ |\$\$ |     \$\$ |  \$\$ |\$\$ |      \$\$ | \$\$ | \$\$ |
                         =+++++++++                       \$\$ |\\$\$\$\$\$\$\$\ \$\$ |      \$\$ |     \\$\$\$\$\$\$\$ |\$\$ |     \\$\$\$\$\$\$  |\$\$ |      \$\$ | \$\$ | \$\$ |
                         =+++++++++                       \__| \_______|\__|      \__|      \_______|\__|      \______/ \__|      \__| \__| \__|
                         .-++++++++                         
                             :-++++                         
                                 :=                        
"


init_script_message(){
    echo -e "\033[38;5;93m$ascii_picture\033[0m"
}

check_terraform_installed() {
    if command -v terraform >/dev/null 2>&1; then
        echo "Terraform is installed. Version: $(terraform --version | head -n 1)"
        return 0
    else
        echo "Terraform is not installed on this system."
        return 1
    fi
}

# 운영 체제를 확인하는 함수
detect_os() {
    local OS=""
    local OS_VERSION=""
    
    # /etc/os-release 파일 확인
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ $ID_LIKE == *"rhel"* || $ID == "rhel" ]]; then
            OS="Red Hat"
        elif [[ $ID == "ubuntu" || $ID_LIKE == *"debian"* ]]; then
            OS="Linux"
        else
            OS="Linux"  # 기본적으로 Linux로 표시
        fi
    elif [ "$(uname)" == "Darwin" ]; then
        # MacOS인 경우
        OS="Mac"
    else
        # 기타 OS
        OS="Unknown"
    fi

    # 결과 반환
    echo "$OS"
}


uninstall_terraform_in_linux(){

    echo "Uninstalling Terraform on Linux..."
    sudo apt remove -y terraform
    echo "Terraform removed successfully."
}

uninstall_terraform_in_redhat(){

    echo "Uninstalling Terraform on Red Hat..."
    sudo yum remove -y terraform
    echo "Terraform removed successfully."
}

uninstall_terraform_in_mac(){

    echo "Uninstalling Terraform on Mac..."
    brew uninstall terraform
    echo "Terraform removed successfully."
}

uninstall_terraform_in_unknown(){
    echo "Uninstalling Terraform manually for Unknown OS..."
    if command -v terraform >/dev/null 2>&1; then
        local terraform_path
        terraform_path=$(command -v terraform)
        sudo rm -f "$terraform_path"
        echo "Terraform binary removed from $terraform_path."
    fi
}

init_script_message

echo "Terraform Uninstallation Script\n"

echo "First, Scan the command and file about Terraform\n"

if check_terraform_installed; then
    OS=$(detect_os)
    echo "Detected OS: $OS\n"
    
    read -p "Do you want to uninstall Terraform? (Y/N) " answer
    if [[ "$answer" == "Y" || "$answer" == "y" ]]; then
        case "$OS" in
            "Linux")
                uninstall_terraform_in_linux
                ;;
            "Red Hat")
                uninstall_terraform_in_redhat
                ;;
            "Mac")
                uninstall_terraform_in_mac
                ;;
            "Unknown")
                uninstall_terraform_in_unknown
                ;;
        esac
    else
        echo "Uninstallation canceled."
    fi
else
    echo "No action needed. Exiting."
fi