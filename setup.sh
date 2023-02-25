#!/bin/bash

# Function to install Oh My Zsh with plugins and theme
install_ohmyzsh() {
    echo "Installing Oh My Zsh..."
    sudo apt update
    sudo apt install -y zsh curl git
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    sudo chsh -s $(which zsh) $USER
    git clone https://github.com/dracula/zsh.git ~/.oh-my-zsh/custom/themes/dracula
    sed -i 's/robbyrussell/dracula/g' ~/.zshrc
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    echo "plugins=(git sudo history jsontools zsh-syntax-highlighting zsh-autosuggestions)" >> ~/.zshrc
    echo "ZSH_THEME=\"dracula\"" >> ~/.zshrc
    source ~/.zshrc
    echo "Oh My Zsh installation complete."
}

# Function to install Docker and Docker Compose
install_docker() {
    echo "Installing Docker and Docker Compose..."
    sudo apt update
    sudo apt install -y ca-certificates curl gnupg lsb-release
    sudo mkdir -m 0755 -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker $USER
    echo "Docker installation complete."
}

# Function to install Ansible
install_ansible() {
    echo "Installing Ansible..."
    sudo apt update
    sudo apt install -y software-properties-common
    sudo apt-add-repository --yes --update ppa:ansible/ansible
    sudo apt install -y ansible
    echo "Ansible installation complete."
}

# Function to install Terraform
install_terraform() {
    echo "Installing Terraform..."
    sudo apt update
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update
    sudo apt install -y terraform
    echo "Terraform installation complete."
}

# Function to install Vagrant
install_vagrant() {
    echo "Installing Vagrant..."
    sudo apt update
    sudo add-apt-repository multiverse && sudo add-apt-repository virtualbox
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update
    sudo apt install -y vagrant virtualbox
    echo "Vagrant installation complete."
}

# Function to install Visual Studio Code
install_vscode() {
    echo "Installing Visual Studio Code..."
    sudo apt update
    sudo apt install -y wget gpg
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update
    sudo apt install -y code 
    rm -f packages.microsoft.gpg
    echo "Visual Studio Code installation complete."
}

# Function to display the menu and install the selected applications
display_menu() {
echo "Select the applications to install (enter comma-separated numbers):"
echo "1. OhMyZsh"
echo "2. Docker"
echo "3. Ansible"
echo "4. Terraform"
echo "5. Vagrant"
echo "6. Visual Studio Code"
read input

for i in $(echo $input | sed "s/,/ /g")
do
    case $i in
        1)
            install_ohmyzsh
            ;;
        2)
            install_docker
            ;;
        3)
            install_ansible
            ;;
        4)
            install_terraform
            ;;
        5)
            install_vagrant
            ;;
        6)
            install_vscode
            ;;
        *)
            echo "Invalid input. Please enter comma-separated numbers from the menu."
            ;;
    esac
done
}

# Call the display_menu function to start the script
display_menu