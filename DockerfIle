# Zend server 9 / apache 2.4 / PHP 7.1 / SSH sur Ubuntu
#
# VERSION               0.0.1
#

FROM     ubuntu:artful
MAINTAINER Gallyoko "yogallyko@gmail.com"

# Definition des constantes
ENV login_ssh="zend"
ENV password_ssh="zend"

# Mise a jour des depots
RUN (apt-get update && apt-get upgrade -y -q && apt-get -y -q autoclean && apt-get -y -q autoremove)
 
# Installation des paquets de base
RUN apt-get install -y -q wget nano openssh-server

# Ajout du depot Zend Server
RUN echo "deb http://repos.zend.com/zend-server/9.1/deb_apache2.4 server non-free" >> /etc/apt/sources.list
RUN wget http://repos.zend.com/zend.key -O- |apt-key add -
RUN apt-get update
# Installation de Zend Server
RUN apt-get install -y -q zend-server-php-7.1

# Ajout utilisateur "${login_ssh}"
RUN adduser --quiet --disabled-password --shell /bin/bash --home /home/${login_ssh} --gecos "User" ${login_ssh}

# Modification du mot de passe pour "${login_ssh}"
RUN echo "${login_ssh}:${password_ssh}" | chpasswd

# Ports
EXPOSE 22 80 10081 10082

# script de lancement des services et d affichage de l'accueil
COPY services.sh /root/services.sh
RUN chmod -f 755 /root/services.sh

# Ajout du script services.sh au demarrage
RUN echo "sh /root/services.sh" >> /root/.bashrc
