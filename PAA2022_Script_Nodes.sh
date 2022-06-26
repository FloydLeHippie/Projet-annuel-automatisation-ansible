#Commenter la source cdrom
sed -e '/cdrom/s/^/#/g' -i /etc/apt/sources.list

#Rajouter la source bullseye-back-ports
echo "deb http://deb.debian.org/debian/ bullseye-backports main contrib" | sudo tee -a /etc/apt/sources.list

#Mise à jours de la liste des paquets
sudo apt update

#Ajout d'un utilisateur ansible
sudo adduser --shell /bin/bash --gecos "" ansible

#Authorisation sudo sans mdp pour l'utilisateur ansible 
echo "ansible ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

sudo usermod -L ansible