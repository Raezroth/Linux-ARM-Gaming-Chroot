# Linux ARM Gaming Container Builder

FROM arm32v7/debian:bookworm

COPY box86-binfmt.sh /box86-binfmt.sh
RUN dpkg --add-architecture arm64
RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y sudo wget gnupg
RUN wget https://itai-nelken.github.io/weekly-box86-debs/debian/box86.list -O /etc/apt/sources.list.d/box86.list
RUN wget -qO- https://itai-nelken.github.io/weekly-box86-debs/debian/KEY.gpg | apt-key add - 
RUN apt update && apt install box86 -y
RUN apt install -y rss-glx:arm64 vulkan-tools:arm64
RUN apt install -y box64
RUN apt install -y rss-glx vulkan-tools
RUN wget https://repo.steampowered.com/steam/archive/stable/steam_latest.deb
RUN apt install -y ./steam_latest.deb

RUN adduser --disabled-password --gecos "" user
