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
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt upgrade -y
    sudo apt install terraform
    echo $(terraform --version)

}

install_terraform_in_redhat(){
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
    sudo yum install terraform
    echo $(terraform --version)

}

install_terraform_in_mac(){
    brew install terraform
    echo $(terraform --version)
}

install_terraform_in_unknown(){
    echo "This OS is Not Supported"
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


# Apply Terraform purple color (ANSI 93) and reset (ANSI 0)
echo -e "\033[38;5;93m$ascii_picture\033[0m"