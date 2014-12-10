

grep "kernel.shmmax=" /etc/sysctl.conf >/dev/null
if [ $? -ne 0 ]; then
  echo "kernel.shmmax=1073741824" >>/etc/sysctl.conf
  echo "kernel.shmall=1073741824" >>/etc/sysctl.conf

fi
sysctl -p

locale-gen en_US ru_RU ru_RU.UTF-8
export LANG="ru_RU.UTF-8"

sudo add-apt-repository multiverse
sudo add-apt-repository restricted
sudo apt-get update

apt-get -y install ssl-cert libssl0.9.8 libossp-uuid16 libxslt1.1 libicu-dev libicu52 libt1-5 t1utils imagemagick msttcorefonts ttf-mscorefonts-installer unixodbc texlive-base libgfs-1.3-2 libxml2

mkdir postgres
cd postgres
wget http://launchpadlibrarian.net/153428081/libicu48_4.8.1.1-12ubuntu2_amd64.deb
dpkg -i libicu*.deb
wget ftp://ftp.etersoft.ru/pub/Etersoft/Postgre@Etersoft/stable/x86_64/Ubuntu/14.04/libpq5.5-9.2eter_9.2.1-eter8ubuntu_amd64.deb
wget ftp://ftp.etersoft.ru/pub/Etersoft/Postgre@Etersoft/stable/x86_64/Ubuntu/14.04/postgre-etersoft9.2-contrib_9.2.1-eter8ubuntu_amd64.deb
wget ftp://ftp.etersoft.ru/pub/Etersoft/Postgre@Etersoft/stable/x86_64/Ubuntu/14.04/postgre-etersoft9.2-seltaaddon_9.2.1-eter8ubuntu_amd64.deb
wget ftp://ftp.etersoft.ru/pub/Etersoft/Postgre@Etersoft/stable/x86_64/Ubuntu/14.04/postgre-etersoft9.2-server_9.2.1-eter8ubuntu_amd64.deb
wget ftp://ftp.etersoft.ru/pub/Etersoft/Postgre@Etersoft/stable/x86_64/Ubuntu/14.04/postgre-etersoft9.2_9.2.1-eter8ubuntu_amd64.deb

dpkg -i *.deb
