# Linux ARM Gaming Container Builder

FROM arm64v8/debian:unstable

COPY box86-binfmt.sh /box86-binfmt.sh
RUN dpkg --add-architecture armhf
RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y sudo wget gnupg
RUN wget https://ryanfortner.github.io/box86-debs/box86.list -O /etc/apt/sources.list.d/box86.list
RUN wget -qO- https://ryanfortner.github.io/box86-debs/KEY.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/box86-debs-archive-keyring.gpg 
RUN apt update && apt install box86-sd845 -y
RUN wget https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list
RUN wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg 
RUN apt update && apt install box64 -y
RUN apt install -y rss-glx:armhf vulkan-tools:armhf
RUN apt install -y rss-glx vulkan-tools
RUN wget https://repo.steampowered.com/steam/archive/stable/steam_latest.deb
RUN apt install -y ./steam_latest.deb

RUN adduser --disabled-password --gecos "" user
