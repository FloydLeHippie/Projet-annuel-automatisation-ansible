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

#Installation d'ansible
sudo apt install ansible -y

#Génération d'une clé SSH
sudo ssh-keygen

#Copie de la clé publique ssh sur les hôtes ansible
read -e -p "Entrez l'adresse ip du node 1 :" IP1
sudo ssh-copy-id ansible@${IP1} -y
read -e -p "Entrez l'adresse ip du node 2 :" IP2
sudo ssh-copy-id ansible@${IP2} -y
read -e -p "Entrez l'adresse ip du node 3 :" IP3
sudo ssh-copy-id ansible@${IP3} -y

#Créeation du fichier hosts
sudo echo "$IP1
$IP2
$IP3" >> ./PAA2022_hosts.txt

sudo ansible-playbook -i PAA2022_hosts -u ansible PAA2022_Playbook_Install_Docker.yml
sudo ansible-playbook -i PAA2022_hosts -u ansible PAA2022_Playbook_PAA2022_Playbook_ZabbixAgent.yml
sudo ansible-playbook -i PAA2022_hosts -u ansible PAA2022_Playbook_.yml
