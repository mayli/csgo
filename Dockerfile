FROM ubuntu:14.04

MAINTAINER Mengyang Li <mayli.he@gmail.com>

# Install dependencies
RUN apt-get update &&\
    apt-get install -y curl lib32gcc1

RUN adduser --disabled-password --gecos '' steam

# Run commands as the steam user
USER steam

# Download and extract SteamCMD
RUN mkdir /home/steam/steamcmd &&\
    cd /home/steam/steamcmd &&\
    curl -s http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar -vxz

# Install CS:GO
RUN mkdir /home/steam/csgo &&\
    cd /home/steam/steamcmd &&\
    ./steamcmd.sh \
        +login anonymous \
        +force_install_dir ../csgo \
        +app_update 740 validate \
        +quit

# Make server port available to host
EXPOSE 27015
EXPOSE 27015/udp

# This container will be executable
WORKDIR /home/steam/csgo
ENTRYPOINT ["./srcds_run"]
