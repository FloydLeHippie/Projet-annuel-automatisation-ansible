#!/bin/bash

NicName=$(ls -I "lo" /sys/class/net)

read -e -p "Entrez l'adresse ip :" IP
read -e -p "Entrez le masque de sous réseau :" MASK
read -e -p "Entrez la passerelle :" GW
read -e -p "Entrez l'adresse ip du DNS :" DNS

echo " # The loopback network interface
auto lo
iface lo inet loopback
#The primary network interface
auto ${NicName}
iface ${NicName}  inet static
 address ${IP}
 netmask ${MASK}
 gateway ${GW}
 dns-nameservers ${DNS}
" | sudo tee /etc/network/interfaces

#Commenter la source cdrom
sudo sed -e '/cdrom/s/^/#/g' -i /etc/apt/sources.list

#Rajouter la source bullseye-back-ports
echo "deb http://deb.debian.org/debian/ bullseye-backports main contrib" | sudo tee -a /etc/apt/sources.list

#Mise à jours de la liste des paquets
sudo apt update

#Ajout d'un utilisateur ansible
sudo adduser --shell /bin/bash --gecos "" ansible

#Authorisation sudo sans mdp pour l'utilisateur ansible 
echo "ansible ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

sudo usermod -L ansible

hostname -I
