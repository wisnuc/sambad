useradd -u 2222 -M -N -l caoyang

passwd caoyang <<< $'123456\n123456\n'
smbpasswd -a caoyang <<< $'123456\n123456\n'
smbpasswd -e caoyang

mkdir -p /srv/samba/guest/
echo "Welcome to use Samba!" >> /srv/samba/guest/welcome.txt

mkdir -p /srv/samba/user/
echo "Hello, Master!" >> /srv/samba/user/welcome.txt
