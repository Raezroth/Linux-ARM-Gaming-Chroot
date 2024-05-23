######################################
# Linux ARM Gaming Container Builder #
######################################
FROM arm64v8/debian:unstable

######################################
# Multiarch system - ARM64 and ARM32 #
######################################
RUN dpkg --add-architecture armhf

RUN apt update

##########################################
# Install prerequisites for adding repos #
########################################## 
RUN DEBIAN_FRONTEND=noninteractive apt install -y sudo wget gnupg

#################
# Install box86 #
#################
RUN wget https://ryanfortner.github.io/box86-debs/box86.list -O /etc/apt/sources.list.d/box86.list
RUN wget -qO- https://ryanfortner.github.io/box86-debs/KEY.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/box86-debs-archive-keyring.gpg 
RUN apt update && apt install box86-sd845 -y

#################
# Install box64 #
#################
RUN wget https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list
RUN wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg 
RUN apt update && apt install box64 -y

#################
# Install Steam #
#################
RUN wget https://repo.steampowered.com/steam/archive/stable/steam_latest.deb
RUN apt install -y ./steam_latest.deb

RUN apt install -y libxcursor1:armhf libxcursor1 libxcomposite1:armhf libxcomposite1 libxdamage1:armhf libxdamage1 libxss1:armhf libxss1 libsdl2-2.0-0:armhf libsdl2-2.0-0 libsm6:armhf libsm6 libxss1:armhf libxss1 libxtst6:armhf libxtst6 libvorbisfile3:armhf libvorbisfile3 xdg-desktop-portal-gtk libpcre3:armhf libpcre3

######################
# Add a user account #
######################
RUN adduser --disabled-password --gecos "" user

###########################################
# Copy box86 binfmt script into container #
###########################################
COPY box86-binfmt.sh /box86-binfmt.sh

################################################################
# Run box86 binfmt script when container starts and then sleep #
################################################################
ENTRYPOINT sh /box86-binfmt.sh && sleep infinity
