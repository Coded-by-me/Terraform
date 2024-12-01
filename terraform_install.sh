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


install_terraform_in_linux(){

    echo "\nLet's install Terraform in Linux"

    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt upgrade -y
    sudo apt install terraform
    echo $(terraform --version)

}

install_terraform_in_redhat(){

    echo "\nLet's install Terraform in Red Hat"

    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
    sudo yum install terraform
    echo $(terraform --version)

}

install_terraform_in_mac(){

    echo "\nLet's install Terraform in Mac"

    brew install terraform
    echo $(terraform --version)
}

install_terraform_in_unknown(){
    echo "\nThis OS is Not Supported"
    echo "BUT, If you want to install terraform through the binary file, PLEASE press 'Y' or 'y'"
    
    read -p "Do you want to install terraform through the binary file? (Y/N) " answer
    
    if [ "$answer" == "Y" ] || [ "$answer" == "y" ]; then
        wget https://releases.hashicorp.com/terraform/$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)/terraform_$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)_linux_amd64.zip
        unzip terraform_*_linux_amd64.zip
        sudo mv terraform /usr/local/bin/
        echo $(terraform --version)
    else
        echo "Installation canceled"
    fi
}

init_script_message

echo "Terraform Installation Script\n"

echo "First, Let's check the OS\n"
OS=$(detect_os)
echo "Your OS is $OS\n"

read -p "Do you want to install Terraform? (Y/N) " answer
if [ "$answer" == "Y" ] || [ "$answer" == "y" ]; then
    if [ "$OS" == "Linux" ]; then
        install_terraform_in_linux
    elif [ "$OS" == "Red Hat" ]; then
        install_terraform_in_redhat
    elif [ "$OS" == "Mac" ]; then
        install_terraform_in_mac
    else
        install_terraform_in_unknown
    fi
fi

echo "\n\nInstallation is completed!"