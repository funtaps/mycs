export steam_user=anonymous
export steam_password=
export metamod_version=1.20
export amxmod_version=1.8.2

apt update && apt install -y lib32gcc1 curl

# Install SteamCMD
mkdir -p /opt/steam && cd /opt/steam && \
    curl -sqL "http://media.steampowered.com/client/steamcmd_linux.tar.gz" | tar zxvf -

# Install HLDS
mkdir -p /opt/hlds
# Workaround for "app_update 90" bug, see https://forums.alliedmods.net/showthread.php?p=2518786
/opt/steam/steamcmd.sh +login $steam_user $steam_password +force_install_dir /opt/hlds +app_update 90 validate +quit
/opt/steam/steamcmd.sh +login $steam_user $steam_password +force_install_dir /opt/hlds +app_update 70 validate +quit || :
/opt/steam/steamcmd.sh +login $steam_user $steam_password +force_install_dir /opt/hlds +app_update 10 validate +quit || :
/opt/steam/steamcmd.sh +login $steam_user $steam_password +force_install_dir /opt/hlds +app_update 90 validate +quit
mkdir -p ~/.steam && ln -s /opt/hlds ~/.steam/sdk32
ln -s /opt/steam/ /opt/hlds/steamcmd
cp files/steam_appid.txt /opt/hlds/steam_appid.txt
cp hlds_run.sh /bin/hlds_run.sh

# Add default config
cp files/server.cfg /opt/hlds/cstrike/server.cfg

# Add maps
cp maps/* /opt/hlds/cstrike/maps/
cp files/mapcycle.txt /opt/hlds/cstrike/mapcycle.txt

# Install metamod
mkdir -p /opt/hlds/cstrike/addons/metamod/dlls
curl -sqL "http://prdownloads.sourceforge.net/metamod/metamod-$metamod_version-linux.tar.gz?download" | tar -C /opt/hlds/cstrike/addons/metamod/dlls -zxvf -
cp files/liblist.gam /opt/hlds/cstrike/liblist.gam
# Remove this line if you aren't going to install/use amxmodx and dproto
cp files/plugins.ini /opt/hlds/cstrike/addons/metamod/plugins.ini

# Install dproto
mkdir -p /opt/hlds/cstrike/addons/dproto
cp files/dproto_i386.so /opt/hlds/cstrike/addons/dproto/dproto_i386.so
cp files/dproto.cfg /opt/hlds/cstrike/dproto.cfg

# Install AMX mod X
curl -sqL "http://www.amxmodx.org/release/amxmodx-$amxmod_version-base-linux.tar.gz" | tar -C /opt/hlds/cstrike/ -zxvf -
curl -sqL "http://www.amxmodx.org/release/amxmodx-$amxmod_version-cstrike-linux.tar.gz" | tar -C /opt/hlds/cstrike/ -zxvf -
cp files/maps.ini /opt/hlds/cstrike/addons/amxmodx/configs/maps.ini

# Add admin
echo "\"STEAM_0:0:40763629\" \"\"  \"abcdefghijklmnopqrstu\" \"ce\"" >> "/opt/hlds/cstrike/addons/amxmodx/configs/users.ini"
